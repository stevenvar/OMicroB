open OByteLib

(******************************************************************************)

let stack_size = ref 128
let heap_size = ref 1024
let arch = ref 16
let output_path = ref None
let debug = ref false
let verbose = ref false
let bytecode_path = ref None
let rusage = ref (fun () -> assert false)

(******************************************************************************)

let spec =
  Arg.align [
    ("-o", Arg.String (fun o -> output_path := Some o),
     "<file.c> Set output file (default: <bytecode>.c)");
    ("-stack-size", Arg.Set_int stack_size,
     Printf.sprintf "<word-nb> Set stack size (default: %d)" !stack_size);
    ("-heap-size", Arg.Set_int heap_size,
     Printf.sprintf "<word-nb> Set heap size (default: %d)" !heap_size);
    ("-arch", Arg.Set_int arch,
     Printf.sprintf "<bit-nb> Set virtual machine architecture (default: %d bits)" !arch);
    ("-debug", Arg.Set debug,
     " Generate code in debug mode (default: no)");
    ("-verbose", Arg.Set verbose,
     " Verbose mode (default: no)");
    ("-version", Arg.Unit (fun () -> print_endline Config.version ; exit 0),
     " Print version and exit");
    ("-help", Arg.Unit (fun () -> !rusage ()),
     "");
    ("--help", Arg.Unit (fun () -> !rusage ()),
      "");
  ]

(******************************************************************************)

let usage =
  Printf.sprintf "\
Usage: %s [ OPTIONS ] <bytecode>\n\
\n\
Options:" Sys.argv.(0)

let () =
  rusage := (fun () -> Arg.usage spec usage; exit 1)

(******************************************************************************)

let usage_error msg =
  Printf.printf "Error: %s.\n\n" msg;
  Arg.usage spec usage;
  exit 1

(******************************************************************************)

let unknow arg =
  if !bytecode_path = None then (
    bytecode_path := Some arg
  ) else (
    usage_error (Printf.sprintf "don't know what to do with: `%s'" arg)
  )

(******************************************************************************)

let () =
  try Arg.parse spec unknow ("\n" ^ usage) with Failure msg ->
    Printf.eprintf "Error: %s.\n%!" msg;
    exit 1

(******************************************************************************)

let bytecode_path =
  match !bytecode_path with
  | None ->
    usage_error "please specify an bytecode file as input"
  | Some bytecode_path ->
    match Filename.extension bytecode_path with
    | "" | ".byte" | ".exe" -> bytecode_path
    | _ -> usage_error "invalid input file path, bytecode file expected"

(******************************************************************************)

let output_path =
  match !output_path with
  | None ->
    Filename.remove_extension bytecode_path ^ ".c"
  | Some path ->
    if not (Tools.is_suffix ~suffix:".o" path)
    then usage_error "invalid output file path, .c expected";
    path

(******************************************************************************)

let heap_size = !heap_size
let stack_size = !stack_size
let arch = !arch
let debug = !debug

let () =
  if heap_size <= 0 then usage_error (Printf.sprintf "invalid heap size: %d" heap_size);
  if stack_size <= 0 then usage_error (Printf.sprintf "invalid stack size: %d" stack_size);
  if not (List.mem arch [ 16; 32; 64 ]) then usage_error (Printf.sprintf "invalid arch: %d (16, 32 or 64 expected)" arch)

(******************************************************************************)

let error msg =
  Printf.eprintf "Error: %s.\n%!" msg;
  (try Sys.remove output_path with _ -> ());
  exit 1

(******************************************************************************)

let () =
  try
    Tools.with_oc output_path (fun oc ->
      let bytefile = Bytefile.read bytecode_path in
      let bytecode = Export.export_code bytefile.Bytefile.code in
      let (_globdata, globnb) = Export.export_data bytefile.Bytefile.data in
      Printf.fprintf oc "#define OCAML_STACK_WOSIZE %d\n" stack_size;
      Printf.fprintf oc "#define OCAML_HEAP_WOSIZE %d\n" heap_size;
      Printf.fprintf oc "#define OCAML_GLOBDATA_WOSIZE %d\n" globnb; 
      Printf.fprintf oc "#define OCAML_BYTECODE_BSIZE %d\n" (List.length bytecode);
      Printf.fprintf oc "#define OCAML_VIRTUAL_ARCH %d\n" arch;
      if debug then Printf.fprintf oc "#define OCAML_DEBUG_MODE\n";
      Printf.fprintf oc "\n";
      Printf.fprintf oc "#include <%s/src/byterun/values.h>\n" Config.builddir;
      Printf.fprintf oc "\n";
      Printf.fprintf oc "val_t ocaml_stack[OCAML_STACK_WOSIZE];\n";
      Printf.fprintf oc "val_t ocaml_heap[OCAML_HEAP_WOSIZE];\n";
      Printf.fprintf oc "val_t ocaml_globdata[OCAML_GLOBDATA_WOSIZE];\n";
      Printf.fprintf oc "\n";
      Printer.print_data oc "PROGMEM opcode_t" "ocaml_bytecode" bytecode;
      Printf.fprintf oc "\n";
      Printf.fprintf oc "#include <%s/src/byterun/interp.c>\n" Config.builddir;
    )
  with
  | Failure msg | Sys_error msg -> error msg
  | exn -> error (Printexc.to_string exn)

(******************************************************************************)
