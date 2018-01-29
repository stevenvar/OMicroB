external run : unit -> unit = "caml_gc_run"
(** Manually run the garbage collector *)

external collections : unit -> int = "caml_gc_collections"
(** Return the number of collection run since the program starts *)
    
external live_words : unit -> int = "caml_gc_live_words"
(** Return the current number of word used in the heap.
    Should be called after Gc.run to obtain the current number
    of words that are reachable from roots. *)

external free_words : unit -> int = "caml_gc_free_words"
(** Return the current number of free words in the heap.
    Should be called after Gc.run to obtain the current number
    of words that are still available in the heap. *)
    
external used_stack_size : unit -> int = "caml_gc_used_stack_size"
(** Return the number of words currently used in the stack. *)

external available_stack_size : unit -> int = "caml_gc_available_stack_size"
(** Return the number of words still available in the stack. *)
