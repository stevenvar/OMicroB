(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* Constants *)

let default_stack_size = 128
let default_heap_size  = 1024
let default_gc         = "MAC"
let default_arch       = 32

let default_ocamlc_options = [ "-w"; "@a"; "-safe-string"; "-strict-sequence"; "-strict-formats" ]

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* Tools *)

let help =
  ref (fun () -> assert false)
  
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

(******************************************************************************)
(* Variables fead during parsing of command line arguments *)
    
let output_files = ref []
let compile_only = ref false
let infer_interf = ref false
let just_print   = ref false
let flash        = ref false
let verbose      = ref false
let local        = ref false

let stack_size   = ref None
let heap_size    = ref None
let gc           = ref None
let arch         = ref None

let mlopts       = ref []
let ccopts       = ref []
let cxxopts      = ref []
let ocopts       = ref []
let avrdudeopts  = ref []

(******************************************************************************)
(* Specification of command line options *)
  
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
    ("-flash", Arg.Set flash,
     " Transfer the program to the micro-controller\n");

    ("-stack-size", Arg.Int (fun sz -> stack_size := Some sz),
     Printf.sprintf "<word-nb> Set stack size (default: %d)" default_stack_size);
    ("-heap-size", Arg.Int (fun sz -> heap_size := Some sz),
     Printf.sprintf "<word-nb> Set heap size (default: %d)" default_heap_size);
    ("-gc", Arg.String (fun s -> gc := Some s),
     Printf.sprintf "<gc-algo> Set garbage collector algorithm Stop&Copy or Mark&Compact (default: %s)" default_gc);
    ("-arch", Arg.Int (fun n -> arch := Some n),
     Printf.sprintf "<bit-nb> Set virtual machine architecture (default: %d)\n" default_arch);

    ("-mlopt", Arg.String (fun opt -> mlopts := opt :: !mlopts),
     "<option> Pass the given option to the OCaml compiler");
    ("-mlopts", Arg.String (fun opts -> mlopts := List.rev (split opts ',') @ !mlopts),
     "<opt1,opt2,...> Pass the given options to the OCaml compiler");
    ("-ccopt", Arg.String (fun opt -> ccopts := opt :: !ccopts),
     "<option> Pass the given option to the C compiler");
    ("-ccopts", Arg.String (fun opts -> ccopts := List.rev (split opts ',') @ !ccopts),
     "<opt1,opt2,...> Pass the given options to the C compiler");
    ("-cxxopt", Arg.String (fun opt -> cxxopts := opt :: !cxxopts),
     "<option> Pass the given option to the AVR C++ compiler");
    ("-cxxopts", Arg.String (fun opts -> cxxopts := List.rev (split opts ',') @ !cxxopts),
     "<opt1,opt2,...> Pass the given options to the AVR C++ compiler");
    ("-ocopt", Arg.String (fun opt -> ocopts := opt :: !ocopts),
     "<option> Pass the given option to the AVR objcopy tool");
    ("-ocopts", Arg.String (fun opts -> ocopts := List.rev (split opts ',') @ !ocopts),
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
    ("-cc", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.cc; exit 0),
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
\  %s [ OPTIONS ] -c <src.mli>            (compile .mli  -> .cmi  using ocamlc)\n\
\  %s [ OPTIONS ] -c <src.ml>             (compile .ml   -> .cmo  using ocamlc)\n\
\  %s [ OPTIONS ] <src.cmo> -o <out.byte> (compile .cmo  -> .byte using ocamlc)\n\
\  %s [ OPTIONS ] <in.byte> -o <out.c>    (compile .byte -> .c    using bc2c)\n\
\  %s [ OPTIONS ] <in.c> -o <out.elf>     (compile .c    -> .elf  using cc)\n\
\  %s [ OPTIONS ] <in.c> -o <out.avr>     (compile .c    -> .avr  using c++ for avr)\n\
\  %s [ OPTIONS ] <in.avr> -o <out.hex>   (compile .avr  -> .hex  using objcopy for avr)\n\
\  %s [ OPTIONS ] -flash <in.hex>         (flash the micro-controller using avrdude)\n\
\  %s ( -where | -ocaml | -ocamlc | -ocamlclean | -bc2c | -cc | -avr-c++ | -avr-objcopy | -avrdude )\n\
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

let output_byte  = ref None
let output_c     = ref None
let output_elf   = ref None
let output_avr   = ref None
let output_hex   = ref None
    
(***)

let set_file kind ext r path =
  match !r with
  | None -> r := Some path
  | Some _ -> error "multiple %s files with extension %s" kind ext
  
(***)

let push_input_file path =
  input_files := path :: !input_files;
  match Filename.extension path with
  | ".ml" | ".mli" -> input_mls := path :: !input_mls
  | ".cmo"         -> input_cmos := path :: !input_cmos
  | ".c"           -> input_cs := path :: !input_cs
  | ".byte"        -> set_file "input" ".byte" input_byte path
  | ""             -> error "don't know what to do with argument %S" path
  | _              -> error "don't know what to do with input file %S" path
     
let push_output_file path =
  match Filename.extension path with
  | ".byte" -> set_file "output" ".byte" output_byte path
  | ".c"    -> set_file "output" ".c"    output_c    path
  | ".elf"  -> set_file "output" ".elf"  output_elf  path
  | ".avr"  -> set_file "output" ".avr"  output_avr  path
  | ".hex"  -> set_file "output" ".hex"  output_hex  path
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

let compile_only = !compile_only
let infer_interf = !infer_interf
let just_print   = !just_print
let flash        = !flash
let local        = !local
let verbose      = !verbose

let stack_size   = !stack_size
let heap_size    = !heap_size
let gc           = !gc
let arch         = !arch

let mlopts       = List.rev !mlopts
let ccopts       = List.rev !ccopts
let cxxopts      = List.rev !cxxopts
let ocopts       = List.rev !ocopts
let avrdudeopts  = List.rev !avrdudeopts

let input_files  = List.rev !input_files
let input_mls    = List.rev !input_mls
let input_cmos   = List.rev !input_cmos
let input_cs     = List.rev !input_cs
let input_byte   = !input_byte

let output_byte  = !output_byte
let output_c     = !output_c
let output_elf   = !output_elf
let output_avr   = !output_avr
let output_hex   = !output_hex

let libdir =
  if local then Filename.concat Config.builddir "lib"
  else Config.libdir
    
let bc2c =
  if local then Filename.concat (Filename.concat Config.builddir "bin") "bc2c"
  else Filename.concat Config.bindir "bc2c"
  
(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* Command run tools *)

let is_str_need_quote str =
  try
    String.iter (fun c ->
      match c with
      | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '-' | '.' | '/' | '@' -> ()
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
  if verbose then Printf.printf "+ %s\n%!" cmd;
  if not just_print then (
    match Sys.command cmd with
    | 0 -> ()
    | errcode -> exit errcode
  )
    
(******************************************************************************)
(* Unexpected argument tools *)
    
let should_be_empty lst =
  match lst with
  | [] -> ()
  | path :: _ -> error "don't know what to do with %S" path

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
(* Manage "compile only" *)

let () =
  if compile_only then (
    should_be_false "-c" "-i" infer_interf;
    should_be_false "-c" "-flash" flash;
    should_be_none_incomp "-c" "-stack-size" stack_size;
    should_be_none_incomp "-c" "-heap-size" heap_size;
    should_be_none_incomp "-c" "-gc" gc;
    should_be_none_incomp "-c" "-arch" arch;
    should_be_empty ccopts;
    should_be_empty cxxopts;
    should_be_empty ocopts;
    should_be_empty avrdudeopts;
    should_be_empty input_cmos;
    should_be_empty input_cs;
    should_be_none_file input_byte;
    should_be_none_file output_byte;
    should_be_none_file output_elf;
    should_be_none_file output_avr;
    should_be_none_file output_hex;

    match input_mls with
    | [] -> error "no input file"
    | _ ->
      let vars = [ ("CAMLLIB", libdir) ] in
      let cmd = [ Config.ocamlc ] @ default_ocamlc_options @ [ "-c" ] @ mlopts @ input_mls in
      run ~vars cmd;
      exit 0;
  )

(******************************************************************************)
(* Manage "infer interface" *)

let () =
  if infer_interf then (
    should_be_false "-i" "-c" compile_only;
    should_be_false "-i" "-flash" flash;
    should_be_none_incomp "-i" "-stack-size" stack_size;
    should_be_none_incomp "-i" "-heap-size" heap_size;
    should_be_none_incomp "-i" "-gc" gc;
    should_be_none_incomp "-i" "-arch" arch;
    should_be_empty ccopts;
    should_be_empty cxxopts;
    should_be_empty ocopts;
    should_be_empty avrdudeopts;
    should_be_empty input_cmos;
    should_be_empty input_cs;
    should_be_none_file input_byte;
    should_be_none_file output_byte;
    should_be_none_file output_elf;
    should_be_none_file output_avr;
    should_be_none_file output_hex;

    match input_mls with
    | [] -> error "no input file"
    | _ :: _ :: _ -> error "too many input files"
    | [ path ] ->
      let vars = [ ("CAMLLIB", libdir) ] in
      let cmd = [ Config.ocamlc ] @ default_ocamlc_options @ [ "-i" ] @ mlopts @ [ path ] in
      run ~vars cmd;
      exit 0;
  )
  
(******************************************************************************)
(* Compile .mli, .ml, .cmo and .c into a .byte *)

let computed_output_byte = ref None
    
let () =
  if input_mls <> [] || input_cmos <> [] then (
    should_be_none_file input_byte;

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
      match output_byte with
      | Some path -> path
      | None ->
        let r = ref "" in
        List.iter (fun path ->
          match Filename.extension path with
          | ".ml" | ".cmo" -> r := Filename.remove_extension path ^ ".byte"
          | _ -> ()
        ) input_files;
        assert (!r <> ""); (* Algorithmically impossible *)
        computed_output_byte := Some !r;
        !r in

    let vars = [ ("CAMLLIB", libdir) ] in
    let cmd = [ Config.ocamlc ] @ default_ocamlc_options @ [ "-custom" ] @ mlopts @ input_paths @ [ "-o"; output_path ] in
    run ~vars cmd;

    let cmd = [ Config.ocamlclean; output_path; "-o"; output_path ] in
    run cmd;
  ) else (
    should_be_empty mlopts;
  )

let computed_output_byte = !computed_output_byte

(******************************************************************************)
(* Compile a .byte into a .c *)

let () =
  if (
    input_mls <> [] || input_cmos <> [] || input_byte <> None
  ) && (
    output_byte = None || output_c <> None || output_elf <> None || output_avr <> None || output_hex <> None
  ) then (
    let stack_size = match stack_size with Some sz -> sz | None -> default_stack_size in
    let heap_size = match heap_size with Some sz -> sz | None -> default_heap_size in
    let gc = match gc with Some s -> s | None -> default_gc in
    let arch = match arch with Some n -> n | None -> default_arch in

    let input_path =
      match input_byte with
      | Some path -> path
      | None ->
        match output_byte with
        | Some path -> path
        | None ->
          match computed_output_byte with
          | Some path -> path
          | None -> assert false (* Algorithmically impossible *) in

    let output_path =
      match output_c with
      | Some path -> path
      | None ->
        match output_byte with
        | Some path -> Filename.remove_extension path ^ ".c"
        | None ->
          match computed_output_byte with
          | Some path -> Filename.remove_extension path ^ ".c"
          | None -> assert false (* Algorithmically impossible *) in

    let cmd = [ bc2c ] in
    let cmd = if local then cmd @ [ "-local" ] else cmd in
    let cmd = cmd @ [
      "-stack-size"; string_of_int stack_size;
      "-heap-size"; string_of_int heap_size;
      "-gc"; gc;
      "-arch"; string_of_int arch;
    ] in
    let cmd = cmd @ List.flatten (List.map (fun path -> [ "-i"; path ]) input_cs) in
    let cmd = cmd @ [
      input_path;
      "-o"; output_path;
    ] in
    run cmd

  ) else (
    should_be_none_option "-stack-size" stack_size;
    should_be_none_option "-heap-size" heap_size;
    should_be_none_option "-gc" gc;
    should_be_none_option "-arch" arch;
  )
    
(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
