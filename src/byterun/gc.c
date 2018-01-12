#include <stdlib.h>
#include <string.h>
#include "values.h"
#include "gc.h"
#include <stdio.h>

extern val_t acc;
extern val_t *sp;

extern val_t env;
extern val_t ocaml_stack[OCAML_STACK_WOSIZE];
extern val_t ocaml_global_data[OCAML_GLOBDATA_NUMBER];

extern void print_stack();

/*
 * implantation d'un S&C
 *
 * avec les fonctions principales suivantes :
 *
 *   gc_init
 *   alloc_small
 *   gc
 *
 * on suppose que la mémoire est dans le sens suivant :
 * ----------------------------------------------------------------
 * | ocaml_global_data ... | heap 1 ....  | heap 2  ....  |  .... stack |
 * ----------------------------------------------------------------
 * avec les propriétés que le premier tas est juste après les globales,
 * sinon il faut connaitre la fin des globales
 */


/* heap1_start et heap2_start : le pointeur de début de chaque tas
 * heap1_end et heap2_end : le pointeur de fin de chaque tas
 * current_heap : 1 ou 2 selon le tas actif
 * les appels d'allocations mémoires ne savent pas dans quel tas seront placé les données.
 */
extern const val_t *ocaml_heap1, *ocaml_heap2;
const val_t *heap1_start, *heap2_start;
const val_t *heap1_end, *heap2_end;
int current_heap;


/* heap_ptr : pointeur du premier emplacement libre du tas
 * heap_end : pointeur de fin du tas courant */
val_t *heap_ptr, *heap_end;

/* heap_todo : indique ce qui reste à déplacer */
val_t *heap_todo;

/* des variables internes utiles pour le gc */
val_t *new_heap, *old_heap;
val_t* tab_heap_start[2];
val_t* tab_heap_end[2];

/* Initialisation du GC
 * Cette fonction doit être appelée avant toute allocation du programme ;
 *   à voir dans startup.c
 * heap_size : la taille du tas utile. Au final 2 zones de cette taille seront allouées.
 */
void gc_init(int32_t heap_size) {
  heap1_start = ocaml_heap1;
  heap1_end = heap1_start + heap_size;
  tab_heap_start[0] = (val_t*)heap1_start;
  tab_heap_end[0] = (val_t*)heap1_end;
  heap2_start = ocaml_heap2;
  heap2_end = heap2_start + heap_size;
  tab_heap_start[1] = (val_t*)heap2_start;
  tab_heap_end[1] = (val_t*)heap2_end;
  #ifdef OCAML_HEAP_INITIAL_WOSIZE
  heap_ptr = (val_t*)heap1_start + OCAML_HEAP_INITIAL_WOSIZE;
  #else
  heap_ptr = (val_t*)heap1_start;
  #endif
  heap_end = (val_t *)heap1_start + heap_size;
  current_heap = 0;
}

val_t Alloc_small_f (mlsize_t wosize, tag_t tag) {
  val_t result;
  Alloc_small(result, wosize, tag);
  return result;
}

#if defined(DEBUG)

int cpt_gc = 0;

void clean_heap(){
  val_t* from = tab_heap_start[(current_heap+1)%2];
  val_t* to = tab_heap_end[(current_heap+1)%2];
  for(val_t* ptr = from ; ptr < to; ptr++){
    *ptr = 0;
  }
}

#ifdef __AVR__
void print_heap(){
  val_t* from = tab_heap_start[current_heap];
  val_t* to = tab_heap_end[current_heap];
  Serial.println("HEAP=");
 for(val_t* ptr = from ; ptr < to; ptr++){
    /* if (*ptr != 0){ */
   Serial.print("@0x");
   Serial.print((val_t)ptr,HEX);
   Serial.print(":");
      if (Is_int(*ptr)){
	Serial.println(Int_val(*ptr),DEC);
      }
      else if (Is_block(*ptr)){
	Serial.println((val_t)Block_val(*ptr),HEX);
      }
      else if (*ptr == 0){
        Serial.println("_");
      }
      else{
        Serial.println(*(float *)ptr,5);
      }
 }
 Serial.println("_____\n");
}
#endif
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#if defined(__PC__)
/* Pour debug */
void print_heap(){
  val_t* ptr;
  int i = 0;
  val_t* from = tab_heap_start[current_heap];
  val_t* to = tab_heap_end[current_heap];
  /* val_t* from = ocaml_heap; */
  /* val_t* to = heap2_end; */
  printf("HEAP ( starts at %p , ends at %p (size = %ld) ) : \n", from , to, to-from );
  for(ptr = ocaml_heap ; ptr < heap2_end ; ptr++){
    float f = *(float *)ptr;
    if (ptr == heap1_end){
      printf("======================================================\n");
    }
    if (Is_int(*ptr)){
      printf("%d  @%p : 0x%08x (int = %d / float = %f)",i, ptr,*ptr, Int_val(*ptr),f);
    }
    else if (Is_block(*ptr)){
      printf("%d  @%p : %p / @(%p)",i, ptr, *ptr,Block_val(*ptr));
    }
    else if (*ptr == 0){
      printf("%d  @%p : _",i, ptr);
    }
    else{
      printf("%d  @%p : 0x%08x (maybe %f)",i, ptr, *ptr,f);
    }
    printf("\n");
    i++;
  }
  printf("\n\n\n");
}

#endif
#endif /* DEBUG */

/* fonction qui traite complètement une racine
 *    c'est-à-dire effectue tous les déplacements attendus
 */
/* tags in values.h */
void gc_one_val(val_t* ptr, int update) {
  val_t val ;
  header_t hd;
  tag_t tag;
  mlsize_t sz;
  int todo = 0;

#ifdef DEBUG
  DEBUGassert(heap_ptr -1 == heap_todo);
#endif

 start:
  val = *ptr;
  /* printf("The address of the val is %p\n", ptr); */
  if (Is_block(val)) {
    /* printf("The val is a pointer to %p \n", Block_val(val));  */
    hd = Hd_val(val);
    if (Is_black_hd(hd)) { /* bloc déjà copié, mettre à jour la référence*/
      /* printf("already copied \n"); */
      *ptr = Field(val, 0);  /* on suppose qu'il y a toujours un champ (attention à [||]*/
      goto next;
    }
    else {                 /* ici il faut le copier*/
      tag = Tag_hd(hd);
      sz = Wosize_hd(hd);
      /* printf("must copy %d blocs \n", sz); */
      if (tag == Infix_tag) {
        val_t start = val - Infix_offset_hd(hd);
        if (!(Is_black_val(start))) { /* déjà déplacé*/
          gc_one_val(&start,1);
        }
        *ptr = Field(start, 0) + Infix_offset_hd(hd);
      }
      else { /* tag < No_scan_tag : tous les autres */
        *heap_ptr = hd;
	heap_ptr ++;
        val_t new_val = Val_block(heap_ptr);
	/* int n = sz ; */
	/* val_t* po = heap_ptr; */
	/* val_t* pi = (Block_val(val)); */
	/* while (n--){ */
	/*   *po++ = *pi++; */
	/* } */
	memcpy(heap_ptr, Block_val(val), sz * sizeof (val_t));
        Field(val, 0) = new_val;
        heap_ptr += sz;
        Hd_val(val) = Set_black_hd(hd); /* bloc  copié, mise à jour de l'entête */
	*ptr = new_val ; /* on le copie systematiquement (à voir pour les glob)*/
      }
    }
  }
  /* else{ */
  /*   /\* printf("The val is %d\n", Int_val(*ptr)); *\/ */
  /* } */

 next:
  if (heap_todo == heap_ptr -1 ) return;
  if (todo == 0) {
    heap_todo++;
    header_t hd_local = *heap_todo;
    todo = Wosize_hd(hd_local);
    /* printf("todo = %d\n", todo); */
    if (Tag_hd(hd_local) >= No_scan_tag)  {
      heap_todo += todo ;
      todo = 0;
      goto next;
    }
  }
  ptr = ++heap_todo;
  todo--;
  goto start;
}


/* fonction principale pour récupérer de la mémoire
 * en effectuant le GC, et en mettant à jour les deux tas
 * sp : le pointeur de pile courant dans interp.c
 *
 */

void gc(mlsize_t size) {
#ifndef NOGC
#ifdef DEBUG
  cpt_gc++;
  #ifdef __PC__
  printf("==================================================GC=====================================\n");
  #endif
    print_heap();
    print_stack();
#endif
  val_t* ptr; /* pointeur de parcours de la pile et des globales  */
  old_heap = tab_heap_start[current_heap % 2];
  current_heap = (current_heap + 1) % 2;
  heap_end = tab_heap_end[current_heap];
  new_heap = tab_heap_start[current_heap];
  heap_ptr = new_heap;
  heap_todo = new_heap - 1;


/* Pourquoi ce ifdef ?  */
/* #ifdef OCAML_HEAP_INITIAL_WOSIZE */
  for (ptr = ocaml_stack + OCAML_STACK_WOSIZE - 1 ; ptr >= sp; ptr--) {
    gc_one_val(ptr, 1);
  }
/* #endif */

  for (ptr = ocaml_global_data; ptr < ocaml_global_data + OCAML_GLOBDATA_NUMBER; ptr++) {
    gc_one_val(ptr, 1);
  }

  gc_one_val(&acc,1);
  gc_one_val(&env,1);


#ifdef DEBUG
   #ifdef __PC__
  int size_after = heap_ptr - new_heap;
  printf("end of GC number %d ", cpt_gc);
  printf("liberated memory : AFTER = %d  / BEFORE = %d %d \n ", size_after, size_before, size_before-size_after  );

  #endif
  clean_heap();
  print_heap();
#endif
  /* il n y a pas eu assez de récupération */
  if (heap_ptr + size > heap_end) {
    #ifdef DEBUG
    #ifdef __PC__
    printf("HEAP OVERFLOW (I needed %d blocks)\n",size);
    #endif
#endif
    exit(200);
  }
#endif
}
