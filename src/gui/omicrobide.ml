open GMain
open GdkKeysyms

let locale = GtkMain.Main.init ()

let main () =
  let window = GWindow.window ~width:640 ~title:"OMicroBIDE" () in
  ignore (window#connect#destroy ~callback:Main.quit);
  let vbox = GPack.vbox ~packing:window#add () in

  (* Menu bar *)
  let menubar = GMenu.menu_bar ~packing:vbox#pack () in
  let factory = new GMenu.factory menubar in
  let accel_group = factory#accel_group in
  window#add_accel_group accel_group;
  let file_menu = factory#add_submenu "File" in

  (* File menu *)
  let factory = new GMenu.factory file_menu ~accel_group in
  ignore (factory#add_item "Quit" ~key:_Q ~callback: Main.quit);

  (* Editor *)
  let editor = GText.view ~editable:true
      ~wrap_mode:`WORD_CHAR
      () in
  let scrolledEditor = GBin.scrolled_window ~height:500 ~packing:vbox#pack
      ~hpolicy:`NEVER ~vpolicy:`AUTOMATIC () in
  scrolledEditor#add (editor :> GObj.widget);

  window#show ();
  Main.main ()

let () = main ()
