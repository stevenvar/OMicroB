

#ifndef CAML_MLVALUES_H
#define CAML_MLVALUES_H

#include <stdint.h>

/* version 32 bits 

   codage des valeurs par du Nan boxing 32 bits avec : 

          float : tels quels avec 1 seul Nan 1111 1111 1000 0000 0000 0000 0000 0000
           int  : 1 bit de marque à la fin ou au début
       pointeur : 0111 1111 1xxx yyyy xxxx yyyy xxxx yyy0  (alignement) 
pointeurs flash : tels quels mais limités à 2^31-2^23 en évitant ainsi d'avoir que des 1 dans la zone Nan

  */


/* représentation uniforme
   val_t : 32 bits 

 */

typedef int32_t  val_t;
typedef int32_t  header_t;
typedef int32_t  tag_t;
typedef int32_t  mlsize_t;


/* Entiers, vrai Nan et pointeur du tas 
   Is_int ne différencie pas entiers et flottants mais cela ne doit pas être gênant dans les switch du filtrage
   Is_nan teste le seul nan
   Is_ptr teste si c'est un pointeur à suivre dans le tas
   et on ne s'intéresse pas au cas d'un pointeur dans la flash (pointeur de fonction)

 */

#define Is_int(x) ((x) & 1) != 0)
#define Is_nan(x) ( (x >> 23) == 512)
#define Is_ptr(x) ( ((x << 31) == 0) && ((x >> 23) == 256))


/* macros de conversion : to_from 

 */

#define Val_int(x)  (((val_t)(x) << 1 ) + 1)
#define Int_val(x) (x) >> 1)

/* Structure de l'entête : est-ce que la couleur est utile ? 

     +--------+-------+-----+
     | wosize |       | tag |
     +--------+-------+-----+
bits  31    10 9     8 7   0

   on reprend la notation ocaml : 

      wosize : taille (en mots) de la partie chamsp du bloc
          hd : l'entête
         tag : la valeur du champ tag de l'entête 
         

  le pointeur sur un bloc démarre après l'entête, c'est-à-dire sur le premier élément du bloc, 
  il faut donc décaler d'un mot pour atteindre l'entête 

  on distingue alors 3 types de pointeurs : 
    bp : pointeur sur le premier octet d'un bloc (un char * (pour les strings ?))
    op : pointeur sur le premier champ du bloc (une val_t) 
    hp : pointeur sur l'entête d'un bloc (a char *)

*/

#define Tag_hd(hd) ((tag_t) ((hd) & 0xFF))
#define Wosize_hd(hd) ((mlsize_t) ((hd) >> 10))

#define Hd_val(val) (((header_t *) (val)) [-1]) 
#define Hd_hp(hp) (* ((header_t *) (hp))) 
#define Hp_val(val) ((char *) (((header_t *) (val)) - 1))
#define Val_hp(hp) ((value) (((header_t *) (hp)) + 1))


#define Num_tags (1 << 8)
#define Max_wosize ((1 << 22) - 1)


#define Wosize_val(val) (Wosize_hd (Hd_val (val)))
#define Wosize_hp(hp) (Wosize_hd (Hd_hp (hp)))

#define No_scan_tag 251

/* 1- si  tag < No_scan_tag : un n-uplet de champs.  */

/* pointeur sur le 1er champ */
#define Op_val(x) ((value *) (x))
/* les champs sont numérotés à partir de 0 */
#define Field(x, i) (((value *)(x)) [i])          

typedef int32_t opcode_t;
typedef opcode_t * code_t;

/* de la doc ocaml : [Forward_tag] et [Infix_tag] doivent être sous No_scan_tag avec [Infix_tag] le plus petit */

/* Forward_tag : pointeur */
#define Forward_tag 250
#define Forward_val(v) Field(v, 0)

/* Infix_tag : là c'est plus compliqué 
     apparait seulement dans les blocs Closure_tag pour les fonctions mutuelle ment récursives
     Infix_tag doit être impair pour être vu comme un entier
     et retourne 1 (modulo 4) : alignement ?
*/
#define Infix_tag 249
#define Infix_offset_hd(hd) (Bosize_hd(hd))
#define Infix_offset_val(v) Infix_offset_hd(Hd_val(v))

/* les booléens sont 0 et 1 */

#define Val_bool(x) Val_int((x) != 0)
#define Bool_val(x) Int_val(x)
#define Val_false Val_int(0)
#define Val_true Val_int(1)
#define Val_not(x) (Val_false + Val_true - (x))

/* Object_tag */
#define Object_tag 248
#define Class_val(val) Field((val), 0)
#define Oid_val(val) Int_val(Field((val), 1))

/* Closure_tag */
#define Closure_tag 247
#define Code_val(val) (((code_t *) (val)) [0]) 

/* Lazy_tag : pour les lazy, à voir avec les Forward_tag */
#define Lazy_tag 246

/* Another special case: variants */
//CAMLextern value caml_hash_variant(char const * tag);

/* 2- Si tag >= No_scan_tag : suite d'octets. */

/* Pointeur sur le premier octet */
#define Bp_val(v) ((char *) (v))
#define Val_bp(p) ((value) (p))
/* les octets sont numérotés à partir de 0. */
#define Byte(x, i) (((char *) (x)) [i])    
#define Byte_u(x, i) (((unsigned char *) (x)) [i]) 

/* Abstract_tag : ne rien faire poru el GC */
#define Abstract_tag 251

/* Strings. */
#define String_tag 252
#define String_val(x) ((char *) Bp_val(x))
//CAMLextern mlsize_t caml_string_length (value);   /* taille en octets */

/* nombres flottants : pour l'historique. */
#define Double_tag 253

/* tableaux de flottants, là aussi c'est historique. */
#define Double_array_tag 254

/* Custom */
#define Custom_tag 255
#define Data_custom_val(v) ((void *) &Field((v), 1))

/* 3- Atomes sont des 0-nuplet, alloués une seule fois (staituqement). */

//CAMLextern header_t caml_atom_table[];
//#define Atom(tag) (Val_hp (&(caml_atom_table [(tag)])))

/* unit */
#define Val_unit Val_int(0)

/* la liste vide  */
#define Val_emptylist Val_int(0)

#endif /* CAML_MLVALUES_H */
