(** Editor widget *)
class editor ?packing ?show () = object (self)
  val view = GText.view ~editable:true ~wrap_mode:`WORD_CHAR
      ~packing:(GBin.scrolled_window ~height:500 ?packing
                  ~hpolicy:`NEVER ~vpolicy:`AUTOMATIC ())#add
      ()

  method set_text = view#buffer#set_text
  method get_text = view#buffer#get_text
end
