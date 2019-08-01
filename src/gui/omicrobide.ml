open GMain
open GdkKeysyms

let locale = GtkMain.Main.init ()

let currentFileName : string option ref = ref None

let editor = GText.view ~editable:true ~wrap_mode:`WORD_CHAR ()

let write_file filename buff =
  let oc = open_out filename in
  output_string oc buff;
  close_out oc

let save filename =
  write_file filename (editor#buffer#get_text ())

let save_as () =
  let saverDialog = GWindow.file_chooser_dialog ~action:`SAVE
      ~title:"Save as" ~deletable:true () in
  saverDialog#add_select_button_stock `SAVE `DELETE_EVENT;
  ignore (saverDialog#connect#response (fun _ ->
      match saverDialog#get_filenames with
      | [] -> ()
      | hd::_ -> (
          currentFileName := Some hd;
          save hd;
          saverDialog#destroy ()
        )
    ));
  saverDialog#show ()

let read_file filename =
  let lines = ref [] in
  let ic = open_in filename in
  (try
    while true; do
      lines := input_line ic :: !lines
    done
  with End_of_file -> close_in ic);
  String.concat "\n" (List.rev !lines)

let open_file () =
  let openerDialog = GWindow.file_chooser_dialog ~action:`OPEN
      ~title:"Open" ~deletable:true () in
  ignore (openerDialog#connect#file_activated (fun () ->
      match openerDialog#get_filenames with
      | [] -> ()
      | hd::_ -> (
          currentFileName := Some hd;
          editor#buffer#set_text (read_file hd);
          openerDialog#destroy ()
        )));
  openerDialog#show ()

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
  ignore (factory#add_item "Open" ~callback: open_file);
  ignore (factory#add_item "Save" ~key:_S ~callback: (fun () ->
      match !currentFileName with
      | Some s -> save s
      | None -> save_as ()));
  ignore (factory#add_item "Save as" ~callback: save_as);
  ignore (factory#add_item "Quit" ~key:_Q ~callback: Main.quit);

  (* Editor *)
  let scrolledEditor = GBin.scrolled_window ~height:600 ~packing:vbox#pack
      ~hpolicy:`NEVER ~vpolicy:`AUTOMATIC () in
  scrolledEditor#add (editor :> GObj.widget);

  window#show ();
  Main.main ()

let () = main ()
