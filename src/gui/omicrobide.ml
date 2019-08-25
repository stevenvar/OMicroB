open GMain
open GdkKeysyms

(* OMicroB location *)
let local = ref false
let () =
  let build_omicrobide = Filename.concat (Filename.concat Config.builddir "bin") "omicrobide" in
  try
    let build_stats = Unix.stat build_omicrobide in
    let my_stats = Unix.stat Sys.argv.(0) in
    if build_stats.Unix.st_ino = my_stats.Unix.st_ino then local := true;
  with _ -> ()
let omicrob =
  if !local then Filename.concat (Filename.concat Config.builddir "bin") "omicrob"
  else Filename.concat Config.bindir "omicrob"

(* Parameters *)
type device = Arduboy | ArduinoUno | ArduinoMega
let device = ref Arduboy
let stack_size = ref 200
let heap_size = ref 200

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
  ignore (saverDialog#connect#response ~callback:(fun _ ->
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
  ignore (openerDialog#connect#file_activated ~callback:(fun () ->
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
      term#print_external ("> "^cmd);
      let ic, oc = Unix.open_process cmd in
      (try while true do term#print_external (input_line ic) done
       with End_of_file -> ());
      ignore (Unix.close_process (ic, oc))) ()

let unixEnv = Unix.environment ()

(** Run a command and print its output followed by its errors in the terminal *)
let run_for_output_and_errors cmd =
  Thread.create (fun () ->
      term#print_external ("> "^cmd);
      let ic, oc, ec = Unix.open_process_full cmd unixEnv in
      (try while true do term#print_external (input_line ic) done
       with End_of_file -> ());
      (try while true do term#print_external_error (input_line ec) done
       with End_of_file -> ());
      ignore (Unix.close_process_full (ic, oc, ec))) ()

(** Compilation command 1 : .ml -> .byte *)
let compilation_command_1 filename =
  Printf.sprintf "%s -v %s -o %s" omicrob
    filename
    ((Filename.remove_extension filename)^".byte")

(** Compilation command 2 : .byte -> end *)
let compilation_command_2 filename =
  Printf.sprintf "%s -v %s -stack-size %d -heap-size %d" omicrob
    ((Filename.remove_extension filename)^".byte")
    !stack_size !heap_size

(** Run both compilation commands in sequence *)
let compilation_command filename =
  Thread.create (fun () ->
      Thread.join (run_for_output_and_errors (compilation_command_1 filename));
      Thread.join (run_for_output (compilation_command_2 filename))) ()

let upload_command filename =
  Printf.sprintf "%s -v %s -flash" omicrob
    ((Filename.remove_extension filename)^".hex")

(** Try to compile the sketch *)
let compile () =
  match !currentFileName with
  | None -> term#print_error "Save your sketch first !"
  | Some s -> (
      save s;
      term#clear ();
      term#print_msg "Compiling...";
      ignore (compilation_command s)
    )

(** Try to compile and simulate the sketch *)
let simulate () =
  match !currentFileName with
  | None -> term#print_error "Save your sketch first !"
  | Some s -> (
      save s;
      term#clear ();
      ignore (Thread.create(fun () ->
          term#print_msg "Compiling...";
          Thread.join (compilation_command s);
          term#print_msg "Simulating...";
          Thread.join (run_for_output_and_errors (Printf.sprintf "%s.elf" (Filename.remove_extension s)))) ())
    )

(** Try to compile and upload the sketch *)
let upload () =
  match !currentFileName with
  | None -> term#print_error "Save your sketch first !"
  | Some s -> (
      save s;
      term#clear ();
      ignore (Thread.create(fun () ->
          term#print_msg "Compiling...";
          Thread.join (compilation_command s);
          term#print_msg "Uploading...";
          Thread.join (run_for_output_and_errors (upload_command s))) ()))

(** Show "Select stack size" dialog *)
let stack_size_dialog menu =
  let dialog = GWindow.dialog ~title:"Set stack size" ~width:250 () in
  let scale = GRange.scale `HORIZONTAL ~packing:dialog#vbox#add
      ~digits:0
      ~adjustment: (GData.adjustment ~lower:20.0 ~upper:400.0 ~step_incr:1.0 ()) () in
  scale#adjustment#set_value (float_of_int !stack_size);
  ignore (dialog#add_button_stock `SAVE `DELETE_EVENT);
  ignore (dialog#connect#response ~callback:(fun _ ->
      stack_size := int_of_float scale#adjustment#value;
      let menuLabel = GMisc.label_cast (List.hd menu#children) in
      menuLabel#set_text (Printf.sprintf "Stack size: %d" !stack_size);
      dialog#destroy ()));
  dialog#show ()

(** Show "Select heap size" dialog *)
let heap_size_dialog menu =
  let dialog = GWindow.dialog ~title:"Set heap size" ~width:250 () in
  let scale = GRange.scale `HORIZONTAL ~packing:dialog#vbox#add
      ~digits:0
      ~adjustment: (GData.adjustment ~lower:20.0 ~upper:400.0 ~step_incr:1.0 ()) () in
  scale#adjustment#set_value (float_of_int !heap_size);
  ignore (dialog#add_button_stock `SAVE `DELETE_EVENT);
  ignore (dialog#connect#response ~callback:(fun _ ->
      heap_size := int_of_float scale#adjustment#value;
      let menuLabel = GMisc.label_cast (List.hd menu#children) in
      menuLabel#set_text (Printf.sprintf "Heap size: %d" !heap_size);
      dialog#destroy ()));
  dialog#show ()

(** Show "About" dialog *)
let about_dialog () =
  let aboutDialog = GWindow.about_dialog ~name:"OMicroB"
      ~authors:["Steven Varoumas";"Benoit Vaugon";"Emmanuel Chailloux";"Basile Pesin"]
      ~license:"CeCILL"
      ~website:"https://github.com/stevenvar/OMicroB"
      ~website_label:"https://github.com/stevenvar/OMicroB" () in
  ignore (aboutDialog#connect#response ~callback:(fun _ ->
      aboutDialog#destroy ()
    ));
  aboutDialog#show ()

let main () =
  ignore (window#connect#destroy ~callback:Main.quit);

  (* Menu bar *)
  let factory = new GMenu.factory menubar in
  let accel_group = factory#accel_group in
  let file_menu = factory#add_submenu "File" in
  let edit_menu = factory#add_submenu "Edit" in
  let sketch_menu = factory#add_submenu "Sketch" in
  let tools_menu = factory#add_submenu "Tools" in
  let help_menu = factory#add_submenu "Help" in

  (* File menu *)
  let factory = new GMenu.factory file_menu ~accel_group in
  ignore (factory#add_item "Open" ~key:_o ~callback: open_file);
  ignore (factory#add_item "Save" ~key:_s ~callback: (fun () ->
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

  (* Tools menu *)
  let factory = new GMenu.factory tools_menu ~accel_group in
  let device_menu = factory#add_submenu "Device type" in
  ignore (factory#add_separator ());
  let stack_size_menu = factory#add_item
      (Printf.sprintf "Stack size: %d" !stack_size) in
  ignore(stack_size_menu#connect#activate
           ~callback:(fun () -> stack_size_dialog stack_size_menu));
  let heap_size_menu = factory#add_item
      (Printf.sprintf "Heap size: %d" !heap_size) in
  ignore(heap_size_menu#connect#activate
           ~callback:(fun () -> heap_size_dialog heap_size_menu));

  (* Device menu *)
  let factory = new GMenu.factory device_menu ~accel_group in
  let device_group = (factory#add_radio_item "Arduboy" ~active:true
                        ~callback:(fun b -> if b then device := Arduboy)
                     )#group in
  ignore (factory#add_radio_item "Arduino Uno" ~group:device_group
         ~callback:(fun b -> if b then device := ArduinoUno));
  ignore (factory#add_radio_item "Arduino Mega 2560" ~group:device_group
            ~callback:(fun b -> if b then device := ArduinoMega));

  (* Help menu *)
  let factory = new GMenu.factory help_menu ~accel_group in
  ignore (factory#add_item "About" ~callback:about_dialog);

  window#add_accel_group accel_group;
  window#show ();
  Main.main ()

let () =
  main ()
