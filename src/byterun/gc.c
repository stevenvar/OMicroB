#include <stdlib.h>
#include <string.h>
#include "values.h"
#include "gc.h"
#include <stdio.h> 

extern val_t acc;
extern val_t ocaml_stack[];
extern val_t env;
extern val_t *sp;
extern val_t ocaml_global_data[];

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
val_t *heap1_start, *heap2_start;
val_t *heap1_end, *heap2_end;
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
    /* il faudra probablement remplacer le malloc */
  heap1_start = (val_t *) malloc(heap_size * sizeof (val_t));
  heap1_end = heap1_start + heap_size * sizeof (val_t);
    tab_heap_start[0] = heap1_start;
    tab_heap_end[0] = heap1_end;

    heap2_start = (val_t *) malloc(heap_size * sizeof (val_t));
    heap2_end = heap2_start + heap_size * sizeof (val_t);
    tab_heap_start[1] = heap2_start;
    tab_heap_end[1] = heap2_end;

    heap_ptr = heap1_start;
    heap_end = heap_ptr + heap_size * sizeof (val_t);

    current_heap = 0;
    printf("init end \n");
}


val_t Alloc_small_f (mlsize_t wosize, tag_t tag) {
    val_t result;
    printf("alloc start \n");
    Alloc_small(result, wosize, tag);
    printf("alloc size = %lu, tag = %d , sp = %p \n",wosize, tag, sp);
    return result;
}


/* fonction qui traite complètement une racine
 *    c'est-à-dire effectue tous les déplacements attendus
 */

void gc_one_val(val_t* ptr, int update) {
    val_t val ;
    header_t hd;
    tag_t tag;
    mlsize_t sz;
    int todo = 0;

   DEBUGassert(heap_ptr == heap_todo);

start:
    val = *ptr;

    if (Is_block(val)) {
        /* tester si c'est une globale ? */
        hd = (Hd_val(val));
        if (Is_black_hd(hd)) { /* bloc déjà copié, mettre à jour la référence*/
            *ptr = Field(val, 0);  /* on suppose qu'il y a toujours un champ (attention à [||]*/
            goto next;
        }
        else {                 /* ici il faut le copier*/
            tag = Tag_hd(hd);
            sz = Wosize_hd(hd);
            if (tag >=  No_scan_tag) { /* le cas où l'on copie sans ensuite parcourir les sous-blocs*/
                *heap_ptr = hd ;
                heap_ptr++;
                val_t new_val = Val_block(heap_ptr);
                memcpy(heap_ptr, Block_val(val), sz * sizeof (val_t));
                Field(val, 0) = new_val;
                heap_ptr += sz;
                Hd_val(val) = Set_black_hd(hd); /* bloc  copié, mise à jour de l'entête */
                /*       if (update) */
                *ptr = new_val ; /* on le copie systematiquement (à voir pour les globales) */
            }
            else if (tag == Infix_tag) {
                val_t start = val - Infix_offset_hd(hd);
                if (Is_black_val(start)) { /* déjà déplacé*/
                    *ptr = Field(Block_val(start), 0) + Infix_offset_hd(hd);
                } else {
                    gc_one_val(&start,1);
                    *ptr = Field(Block_val(start), 0) + Infix_offset_hd(hd);
                }
            }
            else { /* tag < No_scan_tag : tous les autres */
                *heap_ptr = hd; 
                heap_ptr += sizeof (header_t);
                val_t new_val = (val_t)heap_ptr;
                memcpy(heap_ptr, Block_val(val), sz * sizeof (val_t));
                Field(Block_val(val), 0) = (val_t)heap_ptr;
                heap_ptr += sz * sizeof (val_t);
                Hd_val(*ptr) = Set_black_hd(hd); /* bloc  copié, mise à jour de l'entête */
                Field(ptr, 0) = (val_t)new_val;
                /*       if (update) */
                *ptr = new_val ; /* on le copie systematiquement (à voir pour les glob)*/
                /* il faudra faire en tailrec et avec parcours en largeur si possible */
//                val_t * old_addr = (val_t *)new_val ;
//                for (int i = 0 ; i < sz; i++) { gc_one_val(old_addr,1); old_addr++;}
            }
        }
    }

next:
     if (heap_todo == heap_ptr) return;
     if (todo == 0) {
       header_t hd_local = Hd_val(*heap_todo);
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
  printf("gc start \n");
    val_t* ptr; /* pointeur de parcours de la pile et des globales  */
    old_heap = tab_heap_start[current_heap % 2];
    current_heap = (current_heap + 1) % 2;
    heap_end = tab_heap_end[current_heap % 2];
    new_heap = tab_heap_start[current_heap % 2];
    heap_ptr = new_heap;
    heap_todo = new_heap;

    for (ptr = ocaml_stack; ptr != sp; ptr++) {
        gc_one_val(ptr, 1);
    }

    for (ptr = ocaml_global_data; ptr < heap1_start; ptr++) {
        gc_one_val(ptr, 1);  /* c'est ici que l'on pourra avoir traiter les globales*/
    }

    gc_one_val(&acc,1);
    gc_one_val(&env,1);

    /* il n y a pas eu assez de récupération */
    if (heap_ptr + size > heap_end) {exit(200);}

      printf("gc end \n");
}
