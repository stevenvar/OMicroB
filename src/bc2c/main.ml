open OByteLib

(******************************************************************************)

let stack_size = ref 128
let heap_size = ref 1024
let arch = ref Arch.A16
let output_path = ref None
let local = ref false
let debug = ref false
let verbose = ref false
let bytecode_path = ref None
let rusage = ref (fun () -> assert false)

(******************************************************************************)

let spec = [
  ("-o", Arg.String (fun o -> output_path := Some o),
   "<file.c> Set output file (default: <bytecode>.c)");
  ("-stack-size", Arg.Set_int stack_size,
   Printf.sprintf "<word-nb> Set stack size (default: %d)" !stack_size);
  ("-heap-size", Arg.Set_int heap_size,
   Printf.sprintf "<word-nb> Set heap size (default: %d)" !heap_size);
  ("-arch", Arg.Int (fun n -> arch := Arch.of_int n),
   Printf.sprintf "<bit-nb> Set virtual machine architecture (default: %s bits)" (Arch.to_string !arch));
  ("-debug", Arg.Set debug,
   " Generate code in debug mode");
  ("-verbose", Arg.Set verbose,
   " Increase verbosity");
  ("-version", Arg.Unit (fun () -> print_endline Config.version ; exit 0),
   " Print version and exit");
  ("-help", Arg.Unit (fun () -> !rusage ()),
   "");
  ("--help", Arg.Unit (fun () -> !rusage ()),
   "");
]

let spec =
  if not (Sys.file_exists Config.builddir) then spec
  else spec @ [ ("-local", Arg.Set local, " Link with OMicroB build directory instead of installation directory") ]

let spec = Arg.align spec

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
    usage_error "please specify a bytecode file as input"
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
    if Filename.extension path <> ".c"
    then usage_error "invalid output file path, .c expected";
    path

(******************************************************************************)

let heap_size  = !heap_size
let stack_size = !stack_size
let arch       = !arch
let local      = !local
let debug      = !debug

let () =
  if heap_size <= 0 then usage_error (Printf.sprintf "invalid heap size: %d" heap_size);
  if stack_size <= 0 then usage_error (Printf.sprintf "invalid stack size: %d" stack_size)

let byterun_dir =
  if local then [ Config.builddir; "src"; "byterun" ] else [ Config.libdir ]
    
let values_h  = List.fold_right Filename.concat byterun_dir "values.h"
let interp_c  = List.fold_right Filename.concat byterun_dir "interp.c"
let runtime_c = List.fold_right Filename.concat byterun_dir "runtime.c"
let debug_c   = List.fold_right Filename.concat byterun_dir "debug.c"
let gc_c      = List.fold_right Filename.concat byterun_dir "gc.c"

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
      let (bytecode, opgen) = Codegen.export bytefile.Bytefile.code in
      let (_globdata, globnb) = Datagen.export bytefile.Bytefile.data in
      Printf.fprintf oc "#define OCAML_STACK_WOSIZE     %8d\n" stack_size;
      Printf.fprintf oc "#define OCAML_HEAP_WOSIZE      %8d\n" heap_size;
      Printf.fprintf oc "#define OCAML_GLOBDATA_WOSIZE  %8d\n" globnb; 
      Printf.fprintf oc "#define OCAML_BYTECODE_BSIZE   %8d\n" (List.length bytecode);
      Printf.fprintf oc "#define OCAML_PRIMITIVE_NUMBER %8d\n" (Array.length bytefile.Bytefile.prim);
      Printf.fprintf oc "#define OCAML_VIRTUAL_ARCH     %8s\n" (Arch.to_string arch);
      if debug then Printf.fprintf oc "#define OCAML_DEBUG_MODE\n";
      Printf.fprintf oc "\n";
      Printer.print_opgen oc opgen;
      Printf.fprintf oc "\n";
      Printf.fprintf oc "#include <%s>\n" values_h;
      Printf.fprintf oc "\n";
      Printf.fprintf oc "val_t ocaml_stack[OCAML_STACK_WOSIZE];\n";
      Printf.fprintf oc "val_t ocaml_heap[OCAML_HEAP_WOSIZE];\n";
      Printf.fprintf oc "val_t ocaml_globdata[OCAML_GLOBDATA_WOSIZE];\n";
      Printf.fprintf oc "\n";
      Printer.print_prim oc bytefile.Bytefile.prim;
      Printf.fprintf oc "\n";
      Printer.print_c_array oc "PROGMEM opcode_t" "ocaml_bytecode" "OCAML_BYTECODE_BSIZE" bytecode;
      Printf.fprintf oc "\n";
      Printf.fprintf oc "#include <%s>\n" interp_c;
      Printf.fprintf oc "#include <%s>\n" runtime_c;
      Printf.fprintf oc "#include <%s>\n" debug_c;
      Printf.fprintf oc "#include <%s>\n" gc_c;
    )
  with
  | Failure msg | Sys_error msg -> error msg
  | exn -> error (Printexc.to_string exn)

(******************************************************************************)
