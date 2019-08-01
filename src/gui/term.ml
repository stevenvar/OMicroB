(** Terminal widget, used to display messages *)
class term ?packing ?show () = object (self)
  val view = GText.view
      ~packing:(GBin.scrolled_window ~height:150 ?packing ?show
                  ~hpolicy:`NEVER ~vpolicy:`ALWAYS ())#add
      ~wrap_mode:`WORD_CHAR ~editable:false ()
  val content = ref []

  initializer
    view#misc#modify_bg [(`NORMAL, `BLACK)];
    view#misc#modify_fg [(`NORMAL, `WHITE)]

  method print_msg (msg:string) =
    content := !content@[msg];
    view#buffer#set_text (String.concat "\n" !content)

  method print_error (error:string) =
    content := !content@["ERROR: "^error];
    view#buffer#set_text (String.concat "\n" !content)

  method print_external (msg:string) = self#print_msg msg (* TODO *)

  method clear () =
    content := [];
    view#buffer#set_text ""

  end
