open Pic32

let print_string s = digital_write PIN78 LOW
let print_int i = digital_write PIN82 LOW
let print_newline () = digital_write PIN78 LOW



(* ***********************************************************

   Bibliothèque de contraintes sur les domaines finis

   Version v0.1a uniquement avec énumération
   vbersion naïve avec les entiers naturels
   adaptation du code caml-light vers OCaml


   Emmanuel Chailloux

   25 juillet 2018

   ***********************************************************
*)

(* sommaire

  0) prelude pour la compatabilité avec caml-light
  1) type, exceptions et valeurs globales de base
  2) affichage
  3) contraintes et fonctions principales : iN, nOTIN, range, untrail, instanciate, enumerate
  4) autres contraintes et fonctions : sUP, eQ, eQ2, shift_fd, dIFF

*)

(* remarques

   il reste des commentaires à enlever, mais c'est pour conserver un lien avec la version caml-lioght

*)

(* ***********************************************************

0) prelude : compatibilité avec caml-light

   ***********************************************************
*)


let string_of_bool = function true -> "true" | _ -> "false";;
type 'a vect = 'a array ;;

let do_array f a =
let l = Array.length a in
for i=0 to l-1 do f a.(i) done
;;

let do_vect = do_array;;
let make_vect = Array.make;;
let vect_length = Array.length;;

(* fixe l'ordre pour l'évaluation de  f t *)
let rec do_list f l = match l with
[] -> ()
| t::q -> ignore(f t); do_list f q ;;

let make_string = String.make;;

(* ***********************************************************

   1) type, exceptions et valeurs globales de base 

   ***********************************************************

*)

type constraint_type = unit -> unit;;

type domain  = {
           mutable min : int;
           mutable max : int;
           mutable dom : bool vect}
;;

type fd_var  = {
                name       : string;
                domain     : domain ; 
                mutable fp : constraint_type list}
;;


let new_domain a b = 
  (* let a  if a<0 then 0 else a in (* pas forcément utile à ce niveau là*) *)
    let nd = {min = a ; max = b ; dom = make_vect (b+1) true}
    in 
    (if a>0 then for i=0 to (a-1) do nd.dom.(i)<-false done);nd
;;

let new_fd a b name  = 
  {name=name; domain= new_domain a b ; fp = []}
;;

(* représentation unique de empty_fd *)
let d ={min= -2;max= -3;dom=[| |]};;
let empty_fd = {name="empty"; domain = d; fp=[]};;

let debug_flag = ref false;;
let enum_flag = ref false;;

let trail = ref ([] : (domain  * int  ) list);;

exception Bad_store;;

(* là aussi borne naïve *)
let infinity = 100;;

(* ***********************************************************
  
  2) affichage

  ***********************************************************

*)

let print_domain ind d = 
  print_string (make_string (2*ind) ' ');
  print_string ("min "^(string_of_int d.min)^";");
  print_string ("max "^(string_of_int d.max)^";");
  print_string ("dom "); do_vect (function true -> print_string " true " | _ ->print_string " false ") d.dom
;;

let print_fd_var ind vX =
    print_string (make_string (2*ind) ' ');
    print_string ("name "^vX.name^" ;");
    print_domain 0 vX.domain;;


let print_sol vX =
 print_string (vX.name^"="); print_int vX.domain.min ;print_string " "
;;


(* 

  3) fonction .. (range) in_R 

*)

let min d = let m = d.min in if m<0 then 0 else m;;
let max d = d.max ;;
let dom d = d.dom;;

(* non utilisée *)
(* let vald d =
  if d.min != d.max  then [| |]
  else d.dom
;;
*)

let anti_map l = do_list (fun x -> x ()) l
;;

(* iN   :  intersection du domaine d'une variable et d'un intervalle
           en cas de modification -> propagation des contraintes lie'es a` cett evariable *)

(* #uninfix "IN";; *)




(* intersection du domaine d'une variable avec un intervalle *)
let iN vX ry () =
 if ry != empty_fd.domain then 
  let touched = ref false 
  and rx = vX.domain in
 
  let lx = rx.max
  and ly = ry.max in

  if !debug_flag then
  begin
print_string "iN starting "; print_fd_var 1 vX; print_domain 1 rx;
    print_newline();
    print_int lx;print_string " ";print_int ly;print_newline()
  end;
  
  let m = if lx> ly then ly else lx
  and dx = rx.dom
  and dy = ry.dom in
  for i= min rx (*rx.min*) to m
  do
    if dx.(i) then
      if not (dy.(i)) then
      begin
        dx.(i)<-false;
        touched:=true;
        if !enum_flag then trail:=(rx,i)::!trail
      end
  done ;

  if lx>ly then
    for i = m+1 to rx.max do
      if dx.(i) then
      begin
        dx.(i)<-false;
        touched:=true;
        if !enum_flag then trail:=(rx,i)::!trail
      end
    done;

(*    let r = *)
    if  !touched 
    then 
    begin
       for i=min rx (*rx.min*)      to rx.max do if not (dx.(i)) then if i=rx.min then rx.min<-i+1 done;
       for i=rx.max downto min rx (*rx.min*)  do if not (dx.(i)) then if i=rx.max then rx.max<-i-1 done;
         if !debug_flag then
         begin
           print_string "iN ending "; print_fd_var 1 vX; print_domain 1 rx;
           print_newline()
         end;
       if rx.min > rx.max then raise Bad_store  
       else  anti_map vX.fp
    end 
    else ()
(*
    in 

    if !debug_flag then
    begin
      print_domain 3 rx;print_newline();
      print_string "inter_end...";print_newline()
    end;
    if r then anti_map ;;
*)
;;

(* #infix "IN";; *)

(*
#uninfix "PLUS";;

let PLUS rx n = 
let a = if rx.min+n >= 0 then  rx.min+n else -2
and b = if rx.max+n >= 0 then rx.max+n else -1 in

if rx.min=rx.max  
then 
  let nd =    {min = a ; max = b ; dom =make_vect (b+1) false} in 
   (if a >=0 then  nd.dom.(a)<-true);
(*     for i=a to b do nd.dom.(i)<-rx.dom.(i-n) done; *)
    nd
else
   let nd =    {min = a ; max = b ; dom = [||]} in nd

;;

#infix "PLUS";;
  
*)

(* #uninfix "NOTIN";;*)

let nOTIN vX vY () =

 if vY != empty_fd && vX != empty_fd then 
  let ry = vY.domain in
  let vald = ry.min in
  if  vald == ry.max then
  begin
(* print_string "NOTIN"; *)
    let rx = vX.domain in
    let dx = rx.dom in 
    if vald <= rx.max && dx.(vald) then
    begin
      (if !enum_flag then trail:=(rx,vald)::!trail);
       dx.(vald)<-false;
       (if vald==rx.min then
          for i=rx.min to rx.max do if not (dx.(i)) then if i=rx.min then rx.min<-i+1 done
       else if vald == rx.max then
              for i=rx.max downto rx.min  do if not (dx.(i)) then if i=rx.max then rx.max<-i-1 done);
       if rx.min > rx.max then raise Bad_store  
       else  anti_map vX.fp
    end
  end
;;


(*#infix "NOTIN";;*)


(* range : creation d'un intervalle *)
let range a b = 
(* print_string "range";print_newline();*)
(if !debug_flag then 
 begin 
   print_string (("range starting : ")^(string_of_int a)^" "^(string_of_int b));
   print_newline() 
 end);
  if (a>b) || b<0 then empty_fd.domain else
  {min=a; (*if a<0 then 0 else a;*)max=b;dom=
(*  (if a>b or b<0 then (empty_fd.domain.dom) else *)
  let v = make_vect (b+1) true in 
  for i=0 to (a-1) do v.(i)<-false done;
  if !debug_flag then 
  begin
    do_vect (fun x -> print_string (string_of_bool x)) v; 
    print_newline()
  end;
  v};;


(*#uninfix "NOT_IN";;*)

(* let NOT_IN X r () =  *)
   


(* 
  enumeration 
*)

let rec untrail trail old_trail = 
  if trail != old_trail then
  begin
     match trail with 
       (vY,i)::t ->
       begin 
         if vY.dom <> [| |] then
         begin
           vY.dom.(i)<-true;
           (if vY.min > i then vY.min <- i);
           (if vY.max <  i then vY.max<-i)
(*           (if Y.min - 1 = i then for j = Y.min -1 downto 0    do 
                 if (vY.dom.(j)) & (vY.min - 1 = i) then vY.min<-j done);
           (if vY.max + 1 = i then for j = i to (vect_length(vY.dom)-1)  do
                 if (vY.dom.(j)) & (vY.max + 1 = i) then vY.max<-j done)*)
         end
         else
         begin
           (if vY.min > i then vY.min<-i);
           (if vY.max <  i then vY.max<-i)
(*           (if Y.min - 1 = i then Y.min<-i);
           (if vY.max + 1 = i then vY.max<-i)*)
         end;
         untrail t old_trail
       end
     | []->()
  end
;;





let rec instanciate ind vV other_vars all_vars =
let vD = vV.domain in
let len_d = vect_length(vD.dom)
and old_d =  vD.dom
and old_min = vD.min
and old_max = vD.max
and old_trail = !trail in

for i=0 to (len_d -1) 
do
if !debug_flag then
begin   
  do_list (fun vV ->
  print_fd_var ind vV;print_string (" "^(string_of_int i)^" "^(string_of_bool (old_d.(i))));
  print_newline()) all_vars
end;
  if old_d.(i) then
  begin
    let nd = make_vect len_d false in 
    nd.(i)<-true;
    vD.dom<-nd;
    vD.min<-i;
    vD.max<-i;
    try anti_map vV.fp  ;
        if other_vars == [] then 
        begin 
          do_list (print_sol) all_vars;
          print_newline();
(*          exit 1; *)
          raise Bad_store
        end
        else instanciate (ind+1) (List.hd other_vars) (List.tl other_vars) all_vars
    with 
      Bad_store  -> begin untrail !trail old_trail; trail:=old_trail end
  end
done;
  vD.dom<-old_d;
  vD.min<-old_min;
  vD.max<-old_max;
  raise Bad_store
;;


let enumerate lv = 
if (!debug_flag) then begin print_string "Enumeration starting...";print_newline() end;
let enum = !enum_flag in 
enum_flag:=true;
try instanciate 0 (List.hd lv) (List.tl lv) lv
with Bad_store -> enum_flag:=enum ; print_string "No more solutions...";print_newline()
;;

(*

4) autres contraintes et fonctions : sUP, eQ, eQ2, shift_fd, dIFF

 
*)


(* sUP : ou comment e'crire X>Y en utilisant in_fn
         on gele les fonctions correspondant aux contraintes 
         cela permet de manipuler les Y.min, X.max corrects au moment de 
         la propagation
*)

(*#uninfix "SUP";;*)

let sUP vX vY =
  let updateX  = fun () -> (iN vX (range (vY.domain.min+1) vX.domain.max))  ()
  and updateY  = fun () -> (iN vY  (range  vY.domain.min   (vX.domain.max-1)))  ()
  in 
    vY.fp <- updateX::vY.fp;
    vX.fp <- updateY::vX.fp;
    updateX ();
    updateY ()
;;
  
(*#infix "SUP";;*)


let eQ_aux vX vY n () =
  let touche = ref false in 
  (if vY.domain.min + n >  vX.domain.min   then begin vX.domain.min<-vY.domain.min+n; touche:=true end);
  (if vY.domain.max + n <  vX.domain.max   then begin vX.domain.max<-vY.domain.max+n; touche:=true end);
  (if vX.domain.min > vX.domain.max then raise Bad_store);
  if !touche then anti_map vX.fp
;;



(*#uninfix "EQ";;*)


let eQ vX vY n  =
(* print_string "EQ";print_newline(); *)

  let updateX = fun () -> (iN vX (range ((vY.domain.min+n)) ((vY.domain.max+n)))) ()
  and updateY = fun () -> (iN vY  (range ((vX.domain.min-n)) ((vX.domain.max-n)))) ()
  in 
    vY.fp<-updateX::vY.fp;
    vX.fp<-updateY::vX.fp;
    updateX ();
    updateY ()
;;

let eQ2 vX vY n  =
   fun () -> (iN vX (range ((vY.domain.min+n)) ((vY.domain.max+n)))) ()
;;

(* let EQ3 X Y n () =  *)
  

  
let shift_fd vA n =
(* do_list (fun x -> print_int x;print_string " ")[A.domain.min;A.domain.max;n];print_newline();*)
let s = 
let vA_min = vA.domain.min
and vA_max = vA.domain.max in
let vU_min = vA_min+n
and vU_max = vA_max+n in
if vU_max<0 || vU_min > vU_max then
  empty_fd
else
  new_fd vU_min vU_max (vA.name^"*"^(string_of_int n))
in (*print_fd_var 2 s;print_newline();*)s
 ;;




(*
let Umi = if Ami+n < 0 then -2 else Ami+n 
and Uma = if Ama+n < 0 then -1 else Ama+n in 
if Ami = Ama then 
begin
  let nd = 
  {name=A.name^(string_of_int n);
   domain={min = Umi ; max = Uma ; dom = make_vect (Uma+1) false};
   fp=[]} in 
   (if Uma >=0 then  nd.domain.dom.(Uma)<-true);nd
end
else 
{name=A.name^(string_of_int n);domain={min = Umi ; max = Uma ; dom = [||]};fp=[]};;
*)


(* 

   X # Y + n  : 
 
   s'e'crit en plusieurs passes : 
       EQ U Y n         pose les contraintes sur U et Y
       EQ V X (-n)                               V    X
       X NOTIN  U
       Y NOTIN V

*)

let dIFF  vX vY n  = match n with
  0 ->  
    let updateX = fun () -> (nOTIN vX vY) ()
    and updateY = fun () -> (nOTIN vY vX) () in
    vX.fp<-updateY::vX.fp;
    vY.fp<-updateX::vY.fp;
    updateX();
    updateY()
| _ -> 
  let vU = shift_fd vY n
  and vV = shift_fd vX (-n)
  in
(*   if (U==empty_fd & V!=empty_fd ) or (U!=empty_fd & V==empty_fd) then begin print_string "XXX";print_newline() end ; *)
  if  vU != empty_fd && vV != empty_fd  then
  begin
    let updateX = fun () -> (nOTIN vX vU) ()
    and updateY = fun () -> (nOTIN vY vV) ()
    and updateU = eQ2 vU vY n
    and updateV = eQ2 vV vX (-n)
    in 
      vU.fp<-updateX::vU.fp;
      vV.fp<-updateY::vV.fp;
      vY.fp<-updateU::vY.fp;
      vX.fp<-updateV::vX.fp;
      updateX();
      updateY(); 
      updateU();
      updateV()
  end
  else ()
(* print_string "detect empty_fd";print_newline;print_fd_var 1 X;print_newline;print_fd_var 1 Y;print_newline;print_int n;print_newline() *)
;;



(* ***********************************************************

   Exemple des n-reines
   de la bibliothèque de contraintes sur les domaines finis

   Emmanuel Chailloux

   25 juillet 2018

***********************************************************
*)



(*  PROBLEME des n reines *)

let make_queens n =
let rec make_rec p  =
match p with 0 -> []
| _ -> let vQ = new_fd 0 (n-1) ("Q"^(string_of_int p))
in vQ::(make_rec (p-1))
in make_rec n
;;

let rec noattack x l n = match l with
[] -> ()
| y::t -> dIFF x y 0; dIFF x y n; dIFF x y (-n); noattack x t (n+1)
;;

let rec safe  l =  match l with
[] -> ()
| a::t -> noattack a  t 1 ; safe t
;;

let queens n = let l = make_queens n in
safe l;
(*    do_list (print_fd_var 1) l;print_newline(); *)
print_string "STARTING ENUMERATE";print_newline();
enumerate l
;;
pin_mode PIN78 OUTPUT;;
pin_mode PIN82 OUTPUT;;
digital_write PIN78 HIGH;;
digital_write PIN82 HIGH;;
delay 2000;
digital_write PIN78 LOW;;
digital_write PIN82 LOW;;


queens 5;; 

digital_write PIN78 HIGH;;
digital_write PIN82 HIGH;;