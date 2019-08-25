(** Terminal widget, used to display messages *)
class term ?packing ?show () =
  let myview = GText.view
      ~packing:(GBin.scrolled_window ~height:150 ?packing ?show
                  ~hpolicy:`NEVER ~vpolicy:`ALWAYS ())#add
      ~wrap_mode:`WORD_CHAR ~editable:false () in
  object
    val view = myview
    val ideErrorTag = myview#buffer#create_tag ~name:"error"
        [`FOREGROUND_GDK (GDraw.color (`NAME "red"));
         `WEIGHT `BOLD]
    val msgTag = myview#buffer#create_tag ~name:"msg"
        [`FOREGROUND_GDK (GDraw.color (`NAME "cyan"));
         `WEIGHT `BOLD]
    val externalErrorTag = myview#buffer#create_tag ~name:"externalError"
        [`FOREGROUND_GDK (GDraw.color (`NAME "red"))]

  initializer
    view#misc#modify_bg [(`NORMAL, `BLACK)];
    view#misc#modify_fg [(`NORMAL, `WHITE)];

  method print_msg (msg:string) =
    let prevLine = view#buffer#end_iter#line in
    view#buffer#insert (msg^"\n");
    view#buffer#apply_tag msgTag
      ~start:(view#buffer#get_iter (`LINE prevLine)) ~stop:view#buffer#end_iter

  method print_error (error:string) =
    let prevLine = view#buffer#end_iter#line in
    view#buffer#insert (error^"\n");
    view#buffer#apply_tag ideErrorTag
      ~start:(view#buffer#get_iter (`LINE prevLine)) ~stop:view#buffer#end_iter

  method print_external (msg:string) =
    view#buffer#insert (msg^"\n")

  method print_external_error (error:string) =
    let prevLine = view#buffer#end_iter#line in
    view#buffer#insert (error^"\n");
    view#buffer#apply_tag externalErrorTag
      ~start:(view#buffer#get_iter (`LINE prevLine)) ~stop:view#buffer#end_iter

  method clear () =
    view#buffer#set_text ""

  end
