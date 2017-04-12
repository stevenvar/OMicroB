
#include <stdlib.h>
#include <string.h>
#include "debug.h"
#include "values.h"
#include "gc.h"

extern val_t acc;
extern val_t *stack_end;
extern val_t *env;
extern val_t *sp;
extern val_t *global_data;

/*
 * implantation d'un S&C 
 * 
 * avec les fonctions principales suivantes : 
 * 
 *   init_gc 
 *   alloc_small
 *   gc
 * 
 * on suppose que la mémoire est dans le sens suivant : 
 * ----------------------------------------------------------------
 * | global_data ... | heap 1 ....  | heap 2  ....  |  .... stack |
 * ----------------------------------------------------------------
 * avec les propriétés que le premier tas est juste après les globales, 
 * sinon il faut connaitre la fin des globales 
 */


/* heap1_start et heap2_start : le pointeur de début de chaque tas
 * heap1_end et heap2_end : le pointeur de fin de chaque tas
 * current_heap : 1 ou 2 selon le tas actif
 * les appels d'allocations mémoires ne savent pas dans quel tas seront placé les données.
 */
char *heap1_start, *heap2_start;
char *heap1_end, *heap2_end;
int current_heap;

/* heap_ptr : pointeur du premier emplacement libre du tas
 * heap_end : pointeur de fin du tas courant */
char *heap_ptr, *heap_end;

/* des variables internes utiles pour le gc */
char *new_heap, *old_heap;
char* tab_heap_start[2];
char* tab_heap_end[2];

/* Initialisation du GC
 * Cette fonction doit être appelée avant toute allocation du programme ;
 *   à voir dans startup.c
 * heap_size : la taille du tas utile. Au final 2 zones de cette taille seront allouées.
 */
void init_gc(int heap_size) {
  // il faudra probablement remplacer le malloc
  heap1_start = malloc(heap_size * sizeof (val_t));
  heap1_end = heap1_start + heap_size * sizeof (val_t);
  tab_heap_start[0] = heap1_start;
  tab_heap_end[0] = heap1_end;
  
  heap2_start = malloc(heap_size * sizeof (val_t));
  heap2_end = heap2_start + heap_size * sizeof (val_t);
  tab_heap_start[1] = heap2_start;
  tab_heap_end[1] = heap2_end;

  heap_ptr = heap1_start;
  heap_end = heap_ptr + heap_size * sizeof (val_t);

  current_heap = 0;
}


val_t alloc_small (mlsize_t wosize, tag_t tag) {
  val_t result;
  Alloc_small(result, wosize, tag);
  return result;
}


/* fonction qui traite complètement une racine 
 *    c'est-à-dire effectue tous les déplacements attendus
 */

void gc_one_val(val_t* r) {
  val_t v = *r;
  val_t* ptr;
  header_t hd;
  tag_t tag;
  mlsize_t sz;
  
  if (Is_ptr(v)) { 
    // tester si c'est une globale ?
    hd = Hd_val(v);
    if (Is_black_hd(hd)) { // bloc déjà copié, mettre à jour la référence
      *ptr = Field(v, 0);  // on suppose qu'il y a toujours un champ (attention à [||]
    }
    else {                 // ici il faut le copie
     tag = Tag_hd(hd);
     sz = Wosize_hd(hd);
     if (tag >= No_scan_tag) {
       memcpy(new_heap, (void*)hd, sizeof (header_t));
       new_heap += sizeof (header_t);
       memcpy(new_heap,  (void*)v, sz * sizeof (val_t));
       Field(v, 0) = (val_t)new_heap;
       new_heap += sz * sizeof (val_t);
       Hd_val(*ptr) = Blackhd_hd (hd); /* le bloc a été copié, mise à jour de l'entête */
    }
     else {

     }
   }
  }


}

/* fonction principale pour récupérer de la mémoire
 * en effectuant le GC, et en mettant à jour les deux tas 
 * sp : le pointeur de pile courant dans interp.c
 * AFAIRE : 
 */


void gc(int32_t size) {
  val_t* ptr; /* pointeur de parcours de la pile et des globales  */
  old_heap = tab_heap_start[current_heap % 2];
  current_heap = (current_heap + 1) % 2; 
  heap_end = tab_heap_end[current_heap % 2]; 
  new_heap = tab_heap_start[current_heap % 2];
  heap_ptr = new_heap;
 
  for (ptr = stack_end; ptr != sp; ptr--) {
    gc_one_val(ptr);
  }

  for (ptr = global_data; ptr < heap1_start; ptr++) {
    gc_one_val(ptr);
  }

  gc_one_val(&acc);
  gc_one_value(&env);

  // il n'y a pas eu assez de récupération
 if (heap_ptr + size > heap_end) {exit(200);} 
}

