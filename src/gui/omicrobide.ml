open GMain
open GdkKeysyms

let local = ref false

let () =
  let build_omicrobide = Filename.concat (Filename.concat Config.builddir "bin") "omicrobide" in
  try
    let build_stats = Unix.stat build_omicrobide in
    let my_stats = Unix.stat Sys.argv.(0) in
    if build_stats.Unix.st_ino = my_stats.Unix.st_ino then local := true;
  with _ -> ()

let locale = GtkMain.Main.init ()

let currentFileName : string option ref = ref None

let window = GWindow.window ~width:640 ~title:"OMicroBIDE" ()
let vbox = GPack.vbox ~packing:window#add ()
let menubar = GMenu.menu_bar ~packing:vbox#pack ()

(* Editor *)
let editor = new Editor.editor ~packing:vbox#add ()

(* Terminal *)
let term = new Term.term ~packing:vbox#add ()

let write_file filename buff =
  let oc = open_out filename in
  output_string oc buff;
  close_out oc

(** Save the sketch *)
let save filename =
  write_file filename (editor#get_text ())

(** Choose the file to save as *)
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

(** Open the sketch *)
let open_file () =
  let openerDialog = GWindow.file_chooser_dialog ~action:`OPEN
      ~title:"Open" ~deletable:true () in
  ignore (openerDialog#connect#file_activated (fun () ->
      match openerDialog#get_filenames with
      | [] -> ()
      | hd::_ -> (
          currentFileName := Some hd;
          editor#set_text (read_file hd);
          openerDialog#destroy ()
        )));
  openerDialog#show ()

(** Run a command and print its output in the terminal *)
let run_for_output cmd =
  Thread.create (fun () ->
      term#print_msg ("> "^cmd);
      let ic, oc, ec = Unix.open_process_full cmd (Unix.environment ()) in
      let buf = Buffer.create 16 in
      (* Error *)
      (try
         while true do
           Buffer.add_channel buf ec 1
         done
       with End_of_file -> ());
      let _ = Unix.close_process_full (ic, oc, ec) in
      term#print_msg (Buffer.contents buf)) ()

(** Compilation command *)
let compilation_command ?(flash=false) filename =
  let omicrob =
    if !local then Filename.concat (Filename.concat Config.builddir "bin") "omicrob"
    else Filename.concat Config.bindir "omicrob" in
  Printf.sprintf "%s -v %s %s" omicrob
    (if(flash) then "-flash" else "")
    filename

(** Try to compile the sketch *)
let compile () =
  match !currentFileName with
  | None -> term#print_error "Save first !"
  | Some s -> (
      save s;
      term#clear ();
      term#print_msg "Compiling...";
      ignore (run_for_output (compilation_command s))
    )

(** Try to compile and simulate the sketch *)
let simulate () =
  match !currentFileName with
  | None -> term#print_error "Save first !"
  | Some s -> (
      save s;
      term#clear ();
      ignore (Thread.create(fun () ->
          term#print_msg "Compiling...";
          Thread.join (run_for_output (compilation_command s));
          term#print_msg "Simulating...";
          Thread.join (run_for_output (Printf.sprintf "%s.elf" (Filename.remove_extension s)))) ())
    )

(** Try to compile and upload the sketch *)
let upload () =
  match !currentFileName with
  | None -> term#print_error "Save first !"
  | Some s -> (
      save s;
      term#clear ();
      term#print_msg "Compiling and Uploading...";
      ignore (run_for_output (compilation_command ~flash:true s))
    )

let main () =
  ignore (window#connect#destroy ~callback:Main.quit);

  (* Menu bar *)
  let factory = new GMenu.factory menubar in
  let accel_group = factory#accel_group in
  let file_menu = factory#add_submenu "File" in
  let edit_menu = factory#add_submenu "Edit" in
  let sketch_menu = factory#add_submenu "Sketch" in

  (* File menu *)
  let factory = new GMenu.factory file_menu ~accel_group in
  ignore (factory#add_item "Open" ~key:_o ~callback: open_file);
  ignore (factory#add_item "Save" ~key:0x53 ~callback: (fun () ->
      match !currentFileName with
      | Some s -> save s
      | None -> save_as ()));
  ignore (factory#add_item "Save as" ~callback: save_as);
  ignore (factory#add_item "Quit" ~key:_q ~callback: Main.quit);

  (* Edit menu *)
  let factory = new GMenu.factory edit_menu ~accel_group in
  ignore (factory#add_item "Undo" ~key:_z ~callback: editor#undo);
  ignore (factory#add_item "Redo" ~key:_y ~callback: editor#redo);

  (* Sketch menu *)
  let factory = new GMenu.factory sketch_menu ~accel_group in
  ignore (factory#add_item "Check/Compile" ~key:_r ~callback:compile);
  ignore (factory#add_item "Simulate" ~callback:simulate);
  ignore (factory#add_item "Upload" ~key:_u ~callback:upload);

  window#add_accel_group accel_group;
  window#show ();
  Main.main ()

let () =
  main ()
