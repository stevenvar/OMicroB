#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "values.h"
#include "debug.h"
#include "gc.h"

extern val_t acc;
extern val_t *sp;

extern val_t env;
extern val_t ocaml_stack[OCAML_STACK_WOSIZE];
extern val_t ocaml_global_data[OCAML_GLOBDATA_NUMBER];

#define Is_black_hd(hd) ((hd) & Color_black)
#define Is_black_val(val) Is_black_hd(Hd_val(val))
#define Set_black_hd(hd) ((hd) | Color_black)

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
void gc_init(void) {
  heap1_start = ocaml_heap;
  heap1_end = heap1_start + OCAML_HEAP_WOSIZE / 2;
  tab_heap_start[0] = (val_t *) heap1_start;
  tab_heap_end[0] = (val_t *) heap1_end;
  heap2_start = ocaml_heap + OCAML_HEAP_WOSIZE / 2;
  heap2_end = heap2_start + OCAML_HEAP_WOSIZE / 2;
  tab_heap_start[1] = (val_t *) heap2_start;
  tab_heap_end[1] = (val_t *) heap2_end;
  heap_ptr = (val_t *) heap1_start + OCAML_HEAP_INITIAL_WOSIZE;
  heap_end = (val_t *) heap1_start + OCAML_HEAP_WOSIZE / 2;
  current_heap = 0;
}

#if DEBUG >= 3 // DUMP STACK AND HEAP

int cpt_gc = 0;

void clean_heap(){
  val_t* from = tab_heap_start[(current_heap+1)%2];
  val_t* to = tab_heap_end[(current_heap+1)%2];
  for(val_t* ptr = from ; ptr < to; ptr++){
    *ptr = 0;
  }
}

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

void gc(void) {
#if defined(__PC__) && DEBUG >= 1 // TRACE GC RUNS
  printf("#################### STOP & COPY ####################\n");
#endif

#if defined(__PC__) && DEBUG >= 3 // DUMP STACK AND HEAP
  cpt_gc ++;
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

  for (ptr = ocaml_stack + OCAML_STACK_WOSIZE - 1 ; ptr >= sp; ptr--) {
    gc_one_val(ptr, 1);
  }

  for (ptr = ocaml_global_data; ptr < ocaml_global_data + OCAML_GLOBDATA_NUMBER; ptr++) {
    gc_one_val(ptr, 1);
  }

  gc_one_val(&acc,1);
  gc_one_val(&env,1);

#if defined(__PC__) && DEBUG >= 3 // DUMP STACK AND HEAP
  printf("End of GC number %d\n", cpt_gc);
  clean_heap();
  print_heap();
#endif
}
