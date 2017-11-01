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

#ifndef NOGC

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
   Serial.print("@");
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
  for(ptr = from ; ptr < to; ptr++){
    float f = *(float *)ptr;
    if (Is_int(*ptr)){
      printf("%d  @%p : 0x%08x (int = %d / float = %f) | ",i, ptr,*ptr, Int_val(*ptr),f);
    }
    else if (Is_block(*ptr)){
      printf("%d  @%p : %p / @(%p) | ",i, ptr, *ptr,Block_val(*ptr));
    }
    else if (*ptr == 0){
      printf("%d  @%p : _ | ",i, ptr);
    }
    else
      printf("%d  @%p : 0x%08x (=%f) | ",i, ptr, *ptr,f);
    printf("\n");
    i++;
  }
  printf("\n\n________________________ \n");
}

#endif
#endif
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
  DEBUGassert(heap_ptr == heap_todo);
#endif

 start:
  val = *ptr;
  /* printf("ocaml_heap = %p\n", ocaml_heap); */
  printf("\t The val is : 0x%08x \n",val);
  if (Is_block(val)) {
    printf("It's a pointer to %p \n", (val_t*)Block_val(val));
    hd = Hd_val(val);
    if (Is_black_hd(hd)) { /* bloc déjà copié, mettre à jour la référence*/
      printf("It has already been copied \n");
      /* printf("I update the ref to %p \n", Field(val,0)); */
      *ptr = Field(val, 0);  /* on suppose qu'il y a toujours un champ (attention à [||]*/
      goto next;
    }
    else {                 /* ici il faut le copier*/
      tag = Tag_hd(hd);
      sz = Wosize_hd(hd);
      if (tag == Infix_tag) {
        val_t start = val - Infix_offset_hd(hd);
        if (!(Is_black_val(start))) { /* déjà déplacé*/
          gc_one_val(&start,1);
        }
        *ptr = Field(start, 0) + Infix_offset_hd(hd);
      }
      else { /* tag < No_scan_tag : tous les autres */
	/* printf("I put the header in %p \n",heap_ptr); */
        *heap_ptr = hd;
	heap_ptr ++;
	/* printf("I moved heap_ptr to %p \n",heap_ptr); */
        val_t new_val = Val_block(heap_ptr);
	/* printf("The new value is 0x%04x\n", Val_block(new_val)); */
        memcpy(heap_ptr, Block_val(val), sz * sizeof (val_t));
	/* printf("I put %ld bytes starting from %p in %p \n",sz * sizeof(val_t), Block_val(val),heap_ptr); */
        Field(val, 0) = new_val;
	/* printf("I set the old value to point to the new value ( should be @%p, is now @%p) \n",Block_val(new_val),Block_val(val)); */
        heap_ptr += sz;
	/* printf("I move heap_ptr to %p \n",heap_ptr); */
        Hd_val(val) = Set_black_hd(hd); /* bloc  copié, mise à jour de l'entête */
	/* printf("I set the original to black \n"); */
        *ptr = new_val ; /* on le copie systematiquement (à voir pour les glob)*/
      }
    }
  }
 next:
  if (heap_todo == heap_ptr) return;
  if (todo == 0) {
    /* header_t hd_local = Hd_val(*heap_todo); */
    header_t hd_local = *heap_todo;
    /* printf("hd_local = 0x%04x \n",hd_local); */
    todo = Wosize_hd(hd_local);
    if (Tag_hd(hd_local) >= No_scan_tag)  {
      heap_todo += (todo + 1) ;
      todo = 0;
      goto  next;
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
 #ifdef __AVR__
  Serial.println("GC");

  #endif
#ifdef DEBUG
  /* print_heap(); */
#endif
  val_t* ptr; /* pointeur de parcours de la pile et des globales  */
  old_heap = tab_heap_start[current_heap % 2];
  current_heap = (current_heap + 1) % 2;
  heap_end = tab_heap_end[current_heap];
  new_heap = tab_heap_start[current_heap];
  heap_ptr = new_heap;
  heap_todo = new_heap;

  #ifdef OCAML_HEAP_INITIAL_WOSIZE
  for (ptr = ocaml_stack + OCAML_STACK_WOSIZE; ptr >= sp; ptr--) {
    gc_one_val(ptr, 1);
  }
  #endif

  for (ptr = ocaml_global_data; ptr < ocaml_global_data + OCAML_GLOBDATA_NUMBER; ptr++) {
    gc_one_val(ptr, 1);
  }

  /* print_stack(); */
 
  gc_one_val(&acc,1);  
  gc_one_val(&env,1);
  
  /* il n y a pas eu assez de récupération */
  if (heap_ptr + size > heap_end) {
    exit(200);
  }

  #ifdef DEBUG
  clean_heap();
  /* print_heap(); */
  #endif
}

#else

/* heap_ptr : pointeur du premier emplacement libre du tas
 * heap_end : pointeur de fin du tas courant */
val_t *heap_ptr, *heap_end;
#ifdef DEBUG
void print_heap(){
  val_t* ptr;
  int i = 0;
  val_t* from = ocaml_heap;
  val_t* to = heap_end;
  printf("HEAP ( starts at %p , ends at %p (size = %ld) ) : (100 first blocks) \n", from , to, to-from );
  for(ptr = from ; ptr < to; ptr++){
    /* if (*ptr != 0){ */
      if (Is_int(*ptr)){
	printf("%d  @%p : int : %d | ",i, ptr, Int_val(*ptr));
      }
      else if (Is_block(*ptr)){
	printf("%d  @%p : @(%p) | ",i, ptr, Block_val(*ptr));
      }
      else if (*ptr == 0){
	printf("%d  @%p : _ | ",i, ptr);
      }
      else
	printf("%d  @%p : 0x%08x | ",i, ptr, *ptr);
	printf("\n");
    i++;
  }
  printf("\n...\n________________________ \n");
}
#endif



void gc_init(int32_t heap_size) {
  #ifdef OCAML_HEAP_INITIAL_WOSIZE
  heap_ptr = (val_t*)ocaml_heap + OCAML_HEAP_INITIAL_WOSIZE;
  #else
  heap_ptr = (val_t*)ocaml_heap;
  #endif
  heap_end = heap_ptr + (OCAML_HEAP_WOSIZE * 2);
}

#endif
