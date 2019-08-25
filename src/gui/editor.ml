(** Editor widget *)
class editor ?packing ?show () = object
  val view = GSourceView3.source_view ~editable:true ~wrap_mode:`WORD_CHAR
      ~packing:(GBin.scrolled_window ~height:500 ?packing ?show
                  ~hpolicy:`NEVER ~vpolicy:`AUTOMATIC ())#add
      ~show_line_numbers:true ~auto_indent:true
      ()

  initializer
    view#source_buffer#set_highlight_syntax true;
    let manager = GSourceView3.source_language_manager ~default:true in
    view#source_buffer#set_language (manager#language "ocaml")

  method set_text (s:string) = view#buffer#set_text s
  method get_text () = view#buffer#get_text ()

  method undo () =
    if(view#source_buffer#can_undo) then view#source_buffer#undo ()
  method redo () =
    if(view#source_buffer#can_redo) then view#source_buffer#redo ()
end
