open Device_config

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* Constants *)

let default_stack_size = 64
let default_heap_size  = 256
let default_gc         = "MAC"
let default_arch       = 32

let default_ocamlc_options = [ "-g"; "-w"; "A"; "-safe-string"; "-strict-sequence"; "-strict-formats"; "-ccopt"; "-D__OCAML__" ]
let default_cxx_options = [ "-g"; "-Wall"; "-O"; "-std=c++11" ]
let default_avr_cxx_options = [ "-g"; "-fno-exceptions"; "-Wall"; "-std=c++11"; "-O2"; "-Wnarrowing"; "-Wl,-Os"; "-fdata-sections"; "-ffunction-sections"; "-Wl,-gc-sections" ]
let default_xc32_cxx_options = [ "-std=c++11"; "-Wl,--defsym=_min_heap_size=1024" ]

let device_config = ref Device_config.defConfig
let set_config name =
  try device_config := Device_config.get_config name
  with _ ->
    Printf.printf "Error: device %s is not recognized\n" name;
    exit 1

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* Tools *)

let split str c =
  let rec loop acc i j =
    if i < 0 then
      String.sub str (i + 1) (j - i) :: acc
    else if str.[i] = c then
      loop ((String.sub str (i + 1) (j - i)) :: acc) (i - 1) (i - 1)
    else
      loop acc (i - 1) j in
  let len = String.length str in
  if len = 0 then []
  else loop [] (len - 1) (len - 1)

let starts_with str ~sub =
  let str_len = String.length str in
  let sub_len = String.length sub in
  str_len >= sub_len && String.sub str 0 sub_len = sub

let is_substring str ~sub =
  let str_len = String.length str in
  let sub_len = String.length sub in
  try
    for i = 0 to str_len - sub_len do
      if String.sub str i sub_len = sub then raise Exit;
    done;
    false
  with Exit ->
    true

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* Variables fead during parsing of command line arguments *)

let output_files     = ref []
let compile_only     = ref false
let infer_interf     = ref false
let just_print       = ref false
let trace            = ref 0
let sudo             = ref false
let simul            = ref false
let flash            = ref false
let verbose          = ref false
let local            = ref false

let stack_size       = ref None
let heap_size        = ref None
let gc               = ref None
let arch             = ref None
let no_clean_interp  = ref false
let no_shortcut_init = ref false
let no_flash_heap    = ref false
let no_flash_globals = ref false

let mlopts           = ref []
let cxxopts          = ref []
let avrcxxopts       = ref []
let avrobjcopts      = ref []
let avrdudeopts      = ref []

(******************************************************************************)
(* Specification of command line options *)

let help =
  ref (fun () -> assert false)

let () =
  let build_omicrob = Filename.concat (Filename.concat Config.builddir "bin") "omicrob" in
  try
    let build_stats = Unix.stat build_omicrob in
    let my_stats = Unix.stat Sys.argv.(0) in
    if build_stats.Unix.st_ino = my_stats.Unix.st_ino then local := true;
  with _ -> ()

let spec =
  Arg.align (
  [
    ("-c", Arg.Set compile_only,
     " Compile only");
    ("-i", Arg.Set infer_interf,
     " Print inferred interface of a .ml file");
    ("-o", Arg.String (fun path -> output_files := path :: !output_files),
     "<file> Set output file");
    ("-n", Arg.Unit (fun () -> just_print := true; verbose := true),
     " Just print commands, do not execute them");
    ("-v", Arg.Set verbose,
     " Be verbose, print executed commands");
  ] @ (
    if Sys.file_exists Config.builddir then [
      ("-local", Arg.Set local,
       " Use the OMicroB build directory instead of installation directory")
    ] else []
  ) @ [
    ("-trace", Arg.Set_int trace,
     " Set verbosity of traces: print informations about execution at runtime (default: 0)");
    ("-sudo", Arg.Set sudo,
     " Use sudo when flashing the micro-controller with avrdude");
    ("-simul", Arg.Set simul,
     " Execute the program in simulation mode on the computer");
    ("-flash", Arg.Set flash,
     " Transfer the program to the micro-controller with avrdude\n");

    ("-device", Arg.String set_config,
     "<device-name> Set the device to compile for; see -list-devices");
    ("-list-devices", Arg.Unit (fun _ -> List.iter (fun n -> Printf.printf "%s\n" n)
                                   (Device_config.all_config_names ());
                                 exit 0),
     " List available devices\n");

    ("-stack-size", Arg.Int (fun sz -> stack_size := Some sz),
     Printf.sprintf "<word-nb> Set stack size (default: %d)" default_stack_size);
    ("-heap-size", Arg.Int (fun sz -> heap_size := Some sz),
     Printf.sprintf "<word-nb> Set heap size (default: %d)" default_heap_size);
    ("-gc", Arg.String (fun s -> gc := Some s),
     Printf.sprintf "<gc-algo> Set garbage collector algorithm Stop&Copy or Mark&Compact (default: %s)" default_gc);
    ("-arch", Arg.Int (fun n -> arch := Some n),
     Printf.sprintf "<bit-nb> Set virtual machine architecture (default: %d)\n" default_arch);
    ("-no-clean-interpreter", Arg.Set no_clean_interp,
     " Do not remove unused VM instructions, compile and link all of them");
    ("-no-shortcut-initialization", Arg.Set no_shortcut_init,
     " Do not improve starting time by evaluating the program initialization at compile time");
    ("-no-flash-heap", Arg.Set no_flash_heap,
     " Do not use flash to store immutable data from the heap known at compile time");
    ("-no-flash-globals", Arg.Set no_flash_globals,
     " Do not use flash to store immutable entries of the global data table");

    ("-mlopt", Arg.String (fun opt -> mlopts := opt :: !mlopts),
     "<option> Pass the given option to the OCaml compiler");
    ("-mlopts", Arg.String (fun opts -> mlopts := List.rev (split opts ',') @ !mlopts),
     "<opt1,opt2,...> Pass the given options to the OCaml compiler");
    ("-cxxopt", Arg.String (fun opt -> cxxopts := opt :: !cxxopts),
     "<option> Pass the given option to the C compiler");
    ("-cxxopts", Arg.String (fun opts -> cxxopts := List.rev (split opts ',') @ !cxxopts),
     "<opt1,opt2,...> Pass the given options to the C compiler");
    ("-avrcxxopt", Arg.String (fun opt -> avrcxxopts := opt :: !avrcxxopts),
     "<option> Pass the given option to the AVR C++ compiler");
    ("-avrcxxopts", Arg.String (fun opts -> avrcxxopts := List.rev (split opts ',') @ !avrcxxopts),
     "<opt1,opt2,...> Pass the given options to the AVR C++ compiler");
    ("-avrobjcopt", Arg.String (fun opt -> avrobjcopts := opt :: !avrobjcopts),
     "<option> Pass the given option to the AVR objcopy tool");
    ("-avrobjcopts", Arg.String (fun opts -> avrobjcopts := List.rev (split opts ',') @ !avrobjcopts),
     "<opt1,opt2,...> Pass the given options to the AVR objcopy tool");
    ("-avrdudeopt", Arg.String (fun opt -> avrdudeopts := opt :: !avrdudeopts),
     "<option> Pass the given option to the avrdude flashing program");
    ("-avrdudeopts", Arg.String (fun opts -> avrdudeopts := List.rev (split opts ',') @ !avrdudeopts),
     "<opt1,opt2,...> Pass the given options to the avrdude flashing program\n");

    ("-where", Arg.Unit (fun () -> Printf.printf "%s\n%!" (if !local then Filename.concat Config.builddir "lib" else Config.libdir); exit 0),
     " Print location of standard library and exit");
    ("-ocaml", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.ocaml; exit 0),
     " Print location of OCaml toplevel and exit");
    ("-ocamlc", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.ocamlc; exit 0),
     " Print location of OCaml bytecode compiler and exit");
    ("-ocamlclean", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.ocamlclean; exit 0),
     " Print location of ocamlclean and exit");
    ("-bc2c", Arg.Unit (fun () -> Printf.printf "%s\n%!" (if !local then Filename.concat (Filename.concat Config.builddir "bin") "bc2c" else Filename.concat Config.bindir "bc2c"); exit 0),
     " Print location of bc2c and exit");
    ("-cxx", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.cxx; exit 0),
     " Print location of C compiler and exit");
    ("-avr-c++", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.avr_cxx; exit 0),
     " Print location of AVR C++ compiler and exit");
    ("-avr-objcopy", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.avr_objcopy; exit 0),
     " Print location of avr-objcopy and exit");
    ("-avrdude", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.avrdude; exit 0),
     " Print location of avrdude and exit\n");

    ("-version", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.version; exit 0),
     " Print version and exit");
    ("-help", Arg.Unit (fun () -> !help ()),
     " Print list of options and exit");
    ("--help", Arg.Unit (fun () -> !help ()),
     "");
  ])

(******************************************************************************)
(* Documentation of command line options *)

let usage =
  let me = Sys.argv.(0) in
  Printf.sprintf "\
Usages:\n\
\  %s [ OPTIONS ] -c <src.mli>                 (compile .mli  -> .cmi  using ocamlc)\n\
\  %s [ OPTIONS ] -c <src.ml>                  (compile .ml   -> .cmo  using ocamlc)\n\
\  %s [ OPTIONS ] <src.cmo> -o <out.byte>      (compile .cmo  -> .byte using ocamlc)\n\
\  %s [ OPTIONS ] <in.byte> -o <out.c>         (compile .byte -> .c    using bc2c)\n\
\  %s [ OPTIONS ] <in.c> -o <out.elf>          (compile .c    -> .elf  using c++)\n\
\  %s [ OPTIONS ] <in.c> -o <out.avr>          (compile .c    -> .avr  using c++ for avr)\n\
\  %s [ OPTIONS ] <in.avr> -o <out.hex>        (compile .avr  -> .hex  using objcopy for avr)\n\
\  %s [ OPTIONS ] -simul <in.elf> [ sim_prog ] (execute the program in simulation mode)\n\
\  %s [ OPTIONS ] -flash <in.hex>              (flash the micro-controller using avrdude)\n\
\n\
Options:" me me me me me me me me me

(******************************************************************************)
(* Error and help tools *)

let error fmt =
  Printf.ksprintf (fun msg ->
    Printf.eprintf "Error: %s\n" msg;
    Arg.usage spec ("\n" ^ usage);
    exit 1;
  ) fmt

let () =
  help := (fun () ->
    Arg.usage spec usage;
    exit 0;
  )

(******************************************************************************)
(* Parsing of input and output files *)

let input_files  = ref []

let input_mls    = ref []
let input_cmos   = ref []
let input_cs     = ref []
let input_byte   = ref None
let input_avr    = ref None
let input_elf    = ref None
let input_hex    = ref None
let input_pic32_elf = ref None
let input_pic32_hex = ref None

let input_prgms  = ref []

let output_byte  = ref None
let output_c     = ref None
let output_elf   = ref None
let output_avr   = ref None
let output_hex   = ref None
let output_pic32_elf = ref None
let output_pic32_hex = ref None

(***)

let set_file kind ext r path =
  match !r with
  | None -> r := Some path
  | Some _ -> error "multiple %s files with extension %s" kind ext

(***)

let push_input_file path =
  input_files := path :: !input_files;
  match Filename.extension path with
  | ".txt" when String.contains path ' ' -> input_prgms := path :: !input_prgms
  | ""             -> input_prgms := path :: !input_prgms
  | ".ml" | ".mli" -> input_mls := path :: !input_mls
  | ".cmo"         -> input_cmos := path :: !input_cmos
  | ".c"           -> input_cs := path :: !input_cs
  | ".byte"        -> set_file "input" ".byte" input_byte path
  | ".avr"         -> set_file "input" ".avr"  input_avr  path
  | ".elf"         -> set_file "input" ".elf"  input_elf  path
  | ".hex"         -> set_file "input" ".hex"  input_hex  path
  | ".pic32_elf"     -> set_file "input" ".pic32_elf" input_pic32_elf path
  | ".pic32_hex"     -> set_file "input" ".hex" input_pic32_hex path
  | _              -> error "don't know what to do with input file %S" path

let push_output_file path =
  match Filename.extension path with
  | ".byte" -> set_file "output" ".byte" output_byte path
  | ".c"    -> set_file "output" ".c"    output_c    path
  | ".elf"  -> set_file "output" ".elf"  output_elf  path
  | ".avr"  -> set_file "output" ".avr"  output_avr  path
  | ".hex"  -> set_file "output" ".hex"  output_hex  path
  | ".pic32_elf" -> set_file "output" ".pic32_elf" output_pic32_elf path
  | ".pic32_hex" -> set_file "output" ".hex" output_pic32_hex path
  | _       -> error "don't know what to do to generate output file %S" path

(******************************************************************************)
(* Command line parsing *)

let () =
  try
    Arg.parse_argv Sys.argv spec push_input_file ("\n" ^ usage);
    List.iter push_output_file (List.rev !output_files);
  with Arg.Bad msg ->
    Printf.eprintf "Error: %s" msg;
    exit 1

(******************************************************************************)
(* Fix parsed options *)

let compile_only     = !compile_only
let infer_interf     = !infer_interf
let just_print       = !just_print
let trace            = !trace
let sudo             = !sudo
let simul            = !simul
let flash            = !flash
let local            = !local
let verbose          = !verbose

let stack_size       = !stack_size
let heap_size        = !heap_size
let gc               = !gc
let arch             = !arch
let no_clean_interp  = !no_clean_interp
let no_shortcut_init = !no_shortcut_init
let no_flash_heap    = !no_flash_heap
let no_flash_globals = !no_flash_globals

let mlopts           = List.rev !mlopts
let cxxopts          = List.rev !cxxopts
let avrcxxopts       = List.rev !avrcxxopts
let avrobjcopts      = List.rev !avrobjcopts
let avrdudeopts      = List.rev !avrdudeopts

let input_files      = List.rev !input_files
let input_mls        = List.rev !input_mls
let input_cmos       = List.rev !input_cmos
let input_cs         = List.rev !input_cs
let input_byte       = !input_byte
let input_avr        = !input_avr
let input_elf        = !input_elf
let input_hex        = !input_hex
let input_pic32_elf    = !input_pic32_elf
let input_pic32_hex    = !input_pic32_hex

let input_prgms      = List.rev !input_prgms

let output_byte      = !output_byte
let output_c         = !output_c
let output_elf       = !output_elf
let output_avr       = !output_avr
let output_hex       = !output_hex
let output_pic32_elf    = !output_pic32_elf
let output_pic32_hex    = !output_pic32_hex

let libdir =
  if local then Filename.concat Config.builddir "lib"
  else Config.libdir

let includedir =
  if local then Filename.concat Config.builddir "src/byterun"
  else Config.includedir

let libexecdir =
  if local then Filename.concat Config.builddir "bin"
  else Config.libexecdir

let bc2c =
  if local then Filename.concat (Filename.concat Config.builddir "bin") "bc2c"
  else Filename.concat Config.bindir "bc2c"

let ppx_options =
  if arch <> Some 16 then []
  else if local then [ "-ppx"; Filename.concat (Filename.concat Config.builddir "bin") "h15ppx" ]
  else [ "-ppx"; Filename.concat Config.bindir "h15ppx" ]

let () =
  if sudo && not flash then error "the option -sudo is meaningless without -flash"

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* Command run tools *)

let is_str_need_quote str =
  try
    String.iter (fun c ->
      match c with
      | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '-' | '+' | '.' | '/' | '@' | '=' | ',' -> ()
      | _ -> raise Exit
    ) str;
    false
  with Exit ->
    true

let quote_if_needed str =
  if is_str_need_quote str then Filename.quote str
  else str

let run ?(vars=[]) strs =
  let buf = Buffer.create 16 in
  let is_first = ref true in
  List.iter (fun (name, value) ->
    if !is_first then is_first := false else Buffer.add_char buf ' ';
    Buffer.add_string buf (quote_if_needed name);
    Buffer.add_char buf '=';
    Buffer.add_string buf (quote_if_needed value);
  ) vars;
  List.iter (fun str ->
    if !is_first then is_first := false else Buffer.add_char buf ' ';
    Buffer.add_string buf (quote_if_needed str);
  ) strs;
  let cmd = Buffer.contents buf in
  if verbose then Printf.eprintf "+ %s\n%!" cmd;
  if not just_print then (
    match Sys.command cmd with
    | 0 -> ()
    | errcode -> exit errcode
  )

(******************************************************************************)
(* Unexpected argument tools *)

let should_be_empty_options opt lst =
  match lst with
  | [] -> ()
  | _ :: _ -> error "don't know what to do with option %S" opt

let should_be_empty_files lst =
  match lst with
  | [] -> ()
  | path :: _ -> error "don't know what to do with file %S" path

let should_be_false opt1 opt2 b =
  if b then error "incompatible options %S and %S" opt1 opt2

let should_be_none_file opt =
  match opt with
  | None -> ()
  | Some s -> error "don't know what to do with file %S" s

let should_be_none_incomp opt1 opt2 opt =
  match opt with
  | None -> ()
  | Some _ -> error "incompatible options %S and %S" opt1 opt2

let should_be_none_option opt_name opt =
  match opt with
  | None -> ()
  | Some _ -> error "don't know what to do with option %S" opt_name

(******************************************************************************)
(* Default file name computing *)

let last_src =
  let r = ref None in
  List.iter (fun path ->
    match Filename.extension path with
    | ".ml" | ".cmo" -> r := Some path
    | _ -> ()
  ) input_files;
  !r

let input_c =
  if last_src <> None || input_byte <> None || output_byte <> None then
    None
  else
    match input_cs with
    | [ path ] -> Some path
    | [] | _ :: _ :: _ -> None

let no_output_requested =
  output_byte = None && output_c = None && output_elf = None && output_avr = None && output_hex = None

let rec get_first_defined path_opts ext =
  match path_opts with
  | [] -> assert false
  | Some path :: _ -> Filename.remove_extension path ^ ext
  | None :: rest -> get_first_defined rest ext

(******************************************************************************)
(* Manage "compile only" *)

let () =
  if compile_only then (
    should_be_false "-c" "-i" infer_interf;
    should_be_false "-c" "-trace" (trace <> 0);
    should_be_false "-c" "-simul" simul;
    should_be_false "-c" "-flash" flash;
    should_be_none_incomp "-c" "-stack-size" stack_size;
    should_be_none_incomp "-c" "-heap-size" heap_size;
    should_be_none_incomp "-c" "-gc" gc;
    should_be_none_incomp "-c" "-arch" arch;
    should_be_false "-c" "-no-clean-interpreter" no_clean_interp;
    should_be_false "-c" "-no-shortcut-initialization" no_shortcut_init;
    should_be_false "-c" "-no-flash-heap" no_flash_heap;
    should_be_false "-c" "-no-flash-globals" no_flash_globals;
    should_be_empty_options "-cxxopt" cxxopts;
    should_be_empty_options "-avrcxxopts" avrcxxopts;
    should_be_empty_options "-avrobjcopts" avrobjcopts;
    should_be_empty_options "-avrdudeopts" avrdudeopts;
    should_be_empty_files input_cmos;
    should_be_empty_files input_cs;
    should_be_none_file input_byte;
    should_be_none_file input_avr;
    should_be_none_file input_elf;
    should_be_none_file input_hex;
    should_be_none_file output_byte;
    should_be_none_file output_c;
    should_be_none_file output_elf;
    should_be_none_file output_avr;
    should_be_none_file output_hex;

    match input_mls with
    | [] -> error "no input file"
    | _ ->
      let vars = [ ("CAMLLIB", libdir) ] in
      let cmd = [ Config.ocamlc ] @ default_ocamlc_options @ ppx_options @ [ "-c" ] @ mlopts @ input_mls in
      run ~vars cmd;
      exit 0;
  )

(******************************************************************************)
(* Manage "infer interface" *)

let () =
  if infer_interf then (
    should_be_false "-i" "-c" compile_only;
    should_be_false "-i" "-trace" (trace <> 0);
    should_be_false "-i" "-simul" simul;
    should_be_false "-i" "-flash" flash;
    should_be_none_incomp "-i" "-stack-size" stack_size;
    should_be_none_incomp "-i" "-heap-size" heap_size;
    should_be_none_incomp "-i" "-gc" gc;
    should_be_none_incomp "-i" "-arch" arch;
    should_be_false "-i" "-no-clean-interpreter" no_clean_interp;
    should_be_false "-i" "-no-shortcut-initialization" no_shortcut_init;
    should_be_false "-i" "-no-flash-heap" no_flash_heap;
    should_be_false "-i" "-no-flash-globals" no_flash_globals;
    should_be_empty_options "-cxxopt" cxxopts;
    should_be_empty_options "-avrcxxopts" avrcxxopts;
    should_be_empty_options "-avrobjcopts" avrobjcopts;
    should_be_empty_options "-avrdudeopts" avrdudeopts;
    should_be_empty_files input_cmos;
    should_be_empty_files input_cs;
    should_be_none_file input_byte;
    should_be_none_file input_avr;
    should_be_none_file input_elf;
    should_be_none_file input_hex;
    should_be_none_file output_byte;
    should_be_none_file output_c;
    should_be_none_file output_elf;
    should_be_none_file output_avr;
    should_be_none_file output_hex;

    match input_mls with
    | [] -> error "no input file"
    | _ :: _ :: _ -> error "too many input files"
    | [ path ] ->
      let vars = [ ("CAMLLIB", libdir) ] in
      let cmd = [ Config.ocamlc ] @ default_ocamlc_options @ ppx_options @ [ "-i" ] @ mlopts @ [ path ] in
      run ~vars cmd;
      exit 0;
  )

(******************************************************************************)
(* Compile .mli, .ml, .cmo and .c into a .byte *)

let available_byte = ref input_byte

let () =
  if input_mls <> [] || input_cmos <> [] then (
    should_be_none_file input_byte;
    should_be_none_file input_avr;
    should_be_none_file input_elf;
    should_be_none_file input_hex;

    if input_cmos = [] && not (List.exists (fun path -> Filename.extension path = ".ml") input_mls) then (
      error "cannot generate a .byte only with OCaml interfaces";
    );

    let input_paths =
      List.filter (fun path ->
        match Filename.extension path with
        | ".mli" | ".ml" | ".cmo" | ".c" -> true
        | _ -> false
      ) input_files in

    let output_path =
      get_first_defined [
        output_byte;
        output_elf;
        output_avr;
        output_hex;
        last_src;
      ] ".byte" in

    available_byte := Some output_path;

    let vars = [ ("CAMLLIB", libdir) ] in
    let cmd = [ Config.ocamlc ] @ default_ocamlc_options @ ppx_options @ [ "-custom" ] @ mlopts in
    let cmd = if trace > 0 then cmd @ [ "-ccopt"; "-DDEBUG=" ^ string_of_int trace ] else cmd in
    let cmd = cmd @ List.flatten (List.map (fun cxxopt -> [ "-ccopt"; cxxopt ]) cxxopts) in
    let cmd = cmd @ match !device_config.typeD with
      | AVR -> [ "-I"; Filename.concat libdir "targets/avr" ;
                 Filename.concat libdir "targets/avr/avr.cma";
                 "-I"; Filename.concat libdir
                   (Filename.concat "targets/avr" !device_config.folder);
                 Filename.concat libdir
                   (Filename.concat "targets/avr"
                      (Filename.concat !device_config.folder
                         ((String.uncapitalize_ascii !device_config.pins_module)^".cmo")));
                 "-open"; Printf.sprintf "Avr";
                 "-open"; Printf.sprintf "%s" !device_config.pins_module ]
      | PIC32 -> [ "-I"; Filename.concat libdir "targets/pic32" ;
                   Filename.concat libdir "targets/pic32/pic32.cma";
                   "-I"; Filename.concat libdir
                    (Filename.concat "targets/pic32" !device_config.folder);
                   Filename.concat libdir
                    (Filename.concat "targets/pic32"
                      (Filename.concat !device_config.folder
                        ((String.uncapitalize_ascii !device_config.pins_module)^".cmo")));
                  "-open"; Printf.sprintf "Pic32";
                  "-open"; Printf.sprintf "%s" !device_config.pins_module ]
      | NONE -> []
    in
    let cmd = cmd @ input_paths @ [ "-o"; output_path ] in
    run ~vars cmd;

    let cmd = [ Config.ocamlclean; output_path; "-o"; output_path ] in
    run cmd;
  ) else (
    should_be_empty_options "-mlopt" mlopts;
  )

let available_byte = !available_byte

(******************************************************************************)
(* Compile a .byte into a .c *)

let available_c = ref input_c

let () =
  if (
    available_byte <> None
  ) && (
    simul || flash || no_output_requested || output_c <> None || output_elf <> None || output_avr <> None || output_hex <> None
  ) then (
    should_be_none_file input_avr;
    should_be_none_file input_elf;
    should_be_none_file input_hex;

    let stack_size = match stack_size with Some sz -> sz | None -> default_stack_size in
    let heap_size = match heap_size with Some sz -> sz | None -> default_heap_size in
    let gc = match gc with Some s -> s | None -> default_gc in
    let arch = match arch with Some n -> n | None -> default_arch in

    let input_path =
      match available_byte with
      | None -> error "no input file to generate a .c"
      | Some path -> path in

    let output_path =
      get_first_defined [
        output_c;
        output_elf;
        output_avr;
        output_hex;
        Some input_path;
      ] ".c" in

    available_c := Some output_path;

    let cmd = [ bc2c ] in
    let cmd = if local then cmd @ [ "-local" ] else cmd in
    let cmd = cmd @ [
      "-stack-size"; string_of_int stack_size;
      "-heap-size"; string_of_int heap_size;
      "-gc"; gc;
      "-arch"; string_of_int arch;
    ] in
    let cmd = if no_clean_interp then cmd @ [ "-no-clean-interpreter" ] else cmd in
    let cmd = if no_shortcut_init then cmd @ [ "-no-shortcut-initialization" ] else cmd in
    let cmd = if no_flash_heap then cmd @ [ "-no-flash-heap" ] else cmd in
    let cmd = if no_flash_globals then cmd @ [ "-no-flash-globals" ] else cmd in
    let cmd = cmd @ List.flatten (List.map (fun path -> [ "-i"; path ]) input_cs) in
    let cmd = cmd @ [ input_path; "-o"; output_path ] in
    run cmd

  ) else (
    should_be_none_option "-stack-size" stack_size;
    should_be_none_option "-heap-size" heap_size;
    should_be_none_option "-gc" gc;
    should_be_none_option "-arch" arch;
  )

let available_c = !available_c

(******************************************************************************)
(* Compile a .c into a .elf *)

let available_elf = ref input_elf

let () =
  if available_c <> None && (simul || output_elf <> None || no_output_requested) then (
    should_be_none_file input_avr;
    should_be_none_file input_elf;
    should_be_none_file input_hex;

    let input_path =
      match available_c with
      | None -> error "no input file to generate a .elf"
      | Some path -> path in

    let output_path =
      get_first_defined [
        output_elf;
        output_avr;
        output_hex;
        Some input_path;
      ] ".elf" in

    available_elf := Some output_path;

    let cmd = [ Config.cxx ] @ default_cxx_options @ cxxopts in
    let cmd = if trace > 0 then cmd @ [ "-DDEBUG=" ^ string_of_int trace ] else cmd in
    let cmd = cmd @ [ "-I"; Filename.concat includedir "simul" ] in
    let cmd = cmd @ [ input_path; "-o"; output_path ] in
    run cmd
  )

let available_elf = !available_elf 

(******************************************************************************)
(* Compile a .c into a .avr *)

let available_avr = ref input_avr

let () =
  if !device_config.typeD = AVR && (available_c <> None && (flash || output_avr <> None || no_output_requested)) then (
    should_be_none_file input_avr;
    should_be_none_file input_elf;
    should_be_none_file input_hex;

    let input_path =
      match available_c with
      | None -> error "no input file to generate a .avr"
      | Some path -> path in

    let output_path =
      get_first_defined [
        output_avr;
        output_elf;
        output_hex;
        Some input_path;
      ] ".avr" in

    available_avr := Some output_path;

    let cmd = [ Config.avr_cxx ] @ default_avr_cxx_options @ avrcxxopts in
    let cmd = if List.exists (fun avrcxxopt -> starts_with avrcxxopt ~sub:"-mmcu=") avrcxxopts then cmd else cmd @ [ "-mmcu=" ^ !device_config.mmcu ] in
    let cmd = if List.exists (fun avrcxxopt -> starts_with avrcxxopt ~sub:"-DF_CPU=") avrcxxopts then cmd else cmd @ [ "-DF_CPU=" ^ string_of_int !device_config.clock ] in
    let cmd = if trace > 0 then cmd @ [ "-DDEBUG=" ^ string_of_int trace ] else cmd in
    let cmd = cmd @ [ "-I"; Filename.concat includedir "avr" ] in
    let cmd = cmd @ [ "-I"; Filename.concat includedir (Filename.concat "avr" !device_config.folder) ] in
    let cmd = cmd @ [ input_path; "-o"; output_path ] in
    run cmd
  ) else (
    should_be_empty_options "-avrcxxopts" avrcxxopts;
  )

let available_avr = !available_avr

(******************************************************************************)
(* Compile a .avr into a .hex *)

let available_hex = ref input_hex

let () =
  if !device_config.typeD = AVR && (available_avr <> None && (flash || output_hex <> None || no_output_requested)) then (
    should_be_none_file input_hex;

    let input_path =
      match available_avr with
      | None -> error "no input file to generate a .hex"
      | Some path -> path in

    let output_path =
      get_first_defined [
        output_hex;
        output_avr;
        output_elf;
        Some input_path;
      ] ".hex" in

    available_hex := Some output_path;

    let cmd = [ Config.avr_objcopy; "-O"; "ihex"; "-R"; ".eeprom" ] @ avrobjcopts @ [ input_path; output_path ] in
    run cmd
  ) else (
    should_be_empty_options "-avrobjcopts" avrobjcopts;
  )

(******************************************************************************)
(* Compile a .c into a .pic32_elf *)

let available_pic32_elf = ref input_pic32_elf

let () =
  if !device_config.typeD = PIC32 && (available_c <> None && (flash || output_pic32_elf <> None || no_output_requested)) then (
    should_be_none_file input_pic32_elf;

    let input_path =
      match available_c with
      | None -> error "no input file to generate a .pic32_elf"
      | Some path -> path in

    let output_path =
      get_first_defined [
        output_pic32_elf;
        Some input_path;
      ] ".pic32_elf" in

    available_pic32_elf := Some output_path;


    let append_linker_script (ls) = [ "-T"; Filename.concat includedir (Filename.concat "pic32/ld" ls) ] in
    let rec collect_linker_scripts script_list = 
      match script_list with
      | [] -> []
      | head::body -> append_linker_script (head) @ collect_linker_scripts body in
    let cmd = [ Config.xc32_cxx  ] @ default_xc32_cxx_options in
    let cmd = cmd @ [ "-mprocessor=" ^ !device_config.mmcu ] in
    let cmd = cmd @ [ "-I"; Filename.concat includedir "pic32" ] in
    let cmd = cmd @ [ "-I"; Filename.concat includedir (Filename.concat "pic32" !device_config.folder) ] in
    let cmd = cmd @ collect_linker_scripts !device_config.linker_scripts in 
    let cmd = cmd @ [ input_path; "-o"; output_path ] in
    run cmd
  )

let available_pic32_elf = !available_pic32_elf
    

(******************************************************************************)
(* Compile a .pic32_elf into a .hex targetting pic32 *)

let available_pic32_hex = ref input_pic32_hex

let () =
  if !device_config.typeD = PIC32 && (available_pic32_elf <> None && (flash || output_pic32_hex <> None || no_output_requested)) then (
    should_be_none_file input_pic32_hex;

    let input_path =
      match available_pic32_elf with
      | None -> error "no input file to generate a .hex"
      | Some path -> path in

    let output_path =
      get_first_defined [
        output_pic32_elf;
        Some input_path;
      ] ".hex" in

    available_pic32_hex := Some output_path;

    let cmd = [ Config.xc32_bin2hex  ] in
    let cmd = cmd @ [ "-a"; input_path ] in
    run cmd
  ) 

let available_pic32_hex = !available_pic32_hex 


(******************************************************************************)
(* Compile a .c into a .arm.elf TODO *)

(******************************************************************************)
(* Compile a .arm.elf into a .hex targetting microbit TODO *)

let available_hex = !available_hex

(******************************************************************************)
(* Simul *)

let () =
  if simul then (
    let env_path = try Sys.getenv "PATH" ^ ":" ^ libexecdir with _ -> libexecdir in
    let vars = [ ("PATH", env_path) ] in
    let elf_path =
      match available_elf with
      | None -> error "no input file run simulation"
      | Some elf_path -> elf_path in
    let cmd = [ if Filename.is_relative elf_path then Filename.concat Filename.current_dir_name elf_path else elf_path ] @ input_prgms in
    run ~vars cmd
  ) else (
    should_be_empty_files input_prgms;
  )

(******************************************************************************)
(* Flash *)

let tty () =
  let rec find_in_options options =
    match options with
    | "-P" :: tty :: _ -> Some tty
    | _ :: rest -> find_in_options rest
    | [] -> None in
  match find_in_options avrdudeopts with
  | Some tty -> tty
  | None ->
    let dev_paths =
      try Sys.readdir "/dev"
      with _ -> Printf.eprintf "Error: fail to open /dev.\n%!"; exit 1 in
    let available_ttys = ref [] in
    Array.iter (fun dev_path ->
        if is_substring dev_path ~sub:"tty.usbmodem"
        || is_substring dev_path ~sub:"USB"
        || is_substring dev_path ~sub:"ACM"
        then (
          available_ttys := Filename.concat "/dev" dev_path :: !available_ttys;
        )
      ) dev_paths;
    match !available_ttys with
    | [] ->
      Printf.eprintf "Error: no available tty found to flash the micro-controller.\n";
      Printf.eprintf "> Please connect the micro-controller if not already connected.\n";
      Printf.eprintf "> Please reset the micro-controller if not ready to receive a new program.\n";
      Printf.eprintf "> Otherwise, please specify a tty with option -avrdudeopts -P,/dev/ttyXXX.\n";
      exit 1;
    | _ :: _ :: _ as lst ->
      Printf.eprintf "Error: multiple available tty found to flash the micro-controller:\n";
      List.iter (Printf.eprintf "  * %s\n") lst;
      Printf.eprintf "> Please specify a tty with option -avrdudeopts -P,/dev/ttyXXX.\n";
      exit 1;
    | [ tty ] -> tty

let () =
  if flash then (
    if !device_config.typeD = AVR then (
      let path =
        match available_hex with
        | None -> error "no input file to flash the micro-controller"
        | Some path -> path in

      let cmd = if sudo then [ "sudo" ] else [] in
      let cmd = cmd @ [ Config.avrdude ] in
      let cmd = if List.mem "-c" avrdudeopts then cmd else cmd @ [ "-c"; !device_config.avr ] in
      let cmd = if List.mem "-P" avrdudeopts then cmd else cmd @ [ "-P"; tty() ] in
      let cmd = if List.mem "-p" avrdudeopts then cmd else cmd @ [ "-p"; !device_config.mmcu ] in
      let cmd = if List.mem "-b" avrdudeopts then cmd else cmd @ [ "-b"; string_of_int !device_config.baud ] in
      let cmd = cmd @ avrdudeopts @ [ "-v"; "-D"; "-U"; "flash:w:" ^ path ^ ":i" ] in
      run cmd

    ) else if !device_config.typeD = PIC32 then (
      should_be_empty_options "-avrdudeopts" avrdudeopts;
      let path =
        match available_pic32_hex with
        | None -> error "no input file to flash the micro-controller"
        | Some path -> path in

      let cmd = if sudo then [ "sudo" ] else [] in
      let cmd = cmd @ [ Config.pic32prog ] in
      let cmd = cmd @ [ "-d"; tty (); "-b"; (string_of_int !device_config.baud); path] in
      run cmd
    )
  ) else (
    should_be_empty_options "-avrdudeopts" avrdudeopts;
)

(******************************************************************************)
(******************************************************************************)

