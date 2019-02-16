(** These would be contained inside the standard library *)
external callback_1: (int -> unit) -> unit = "callback_test_1"
external callback_2: (int -> int -> unit) -> unit = "callback_test_2"
external callback_3: (int -> int -> int -> unit) -> unit = "callback_test_3"
external callback_6: (int -> int -> int ->
                     int -> int -> int -> unit) -> unit = "callback_test_6"

let callback_ret f =
  let with_ret = (fun x -> let res = f x in
                    trace "Retour de la fonction: "; tracei res) in
  callback_1 with_ret

(** Actual program *)
let _ =
  callback_1 (fun a -> tracei (a+1));
  trace "Callback 1 is over !";
  callback_2 (fun a b -> tracei (a-b+1));
  trace "Callback 2 is over !";
  callback_3 (fun a b c -> tracei (a+b-c+1));
  trace "Callback 3 is over !";

  callback_6 (fun a b c d e f -> tracei (a-b+c-d+e-f+1));
  trace "Callback 3 is over !";

  callback_ret (fun a -> (a+1));

  (* The exception is correctly caught *)
  try callback_1 (fun _ -> failwith "Unforeseen exception");
  with Failure _ -> trace "Exception caught"
