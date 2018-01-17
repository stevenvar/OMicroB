external length : 'a array -> int = "%array_length"
external get: 'a array -> int -> 'a = "%array_safe_get"
external set: 'a array -> int -> 'a -> unit = "%array_safe_set"
external unsafe_get: 'a array -> int -> 'a = "%array_unsafe_get"
external unsafe_set: 'a array -> int -> 'a -> unit = "%array_unsafe_set"
external make: int -> 'a -> 'a array = "caml_make_vect"
(* external create: int -> 'a -> 'a array = "caml_make_vect" *)

let make_matrix sx sy init =
  let res = make sx [||] in
  for x = 0 to pred sx do
    unsafe_set res x (make sy init)
  done;
  res

let init l f =
  if l = 0 then [||] else
  if l < 0 then invalid_arg "Array.init"
  (* See #6575. We could also check for maximum array size, but this depends
     on whether we create a float array or a regular one... *)
  else
   let res = make l (f 0) in
   for i = 1 to pred l do
     unsafe_set res i (f i)
   done;
   res

let iter f a =
  for i = 0 to length a - 1 do f(unsafe_get a i) done

let iteri f a =
  for i = 0 to length a - 1 do f i (unsafe_get a i) done
