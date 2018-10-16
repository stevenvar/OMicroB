class point (x:int) (y:int) =
  object (self)
    val mutable x = x
    val mutable y = y
    method get_x () = x
    method get_y () = y
  end

(* class bidule =
 *   object (self)
 *   end *)

(* let _ = *)
  (* let b = new bidule in b *)

let _ =
  let p1 = new point 3 4 in
  p1#get_x
