open OByteLib
open! Analyser

(******************************************************************************)

let stack_size = ref 64
let heap_size = ref 256
let gc = ref "MAC"
let arch = ref Arch.A32
let output_path = ref None
let local = ref false
let debug = ref false
let verbose = ref false
let bytecode_path = ref None
let lincludes = ref []
let gincludes = ref []
let rusage = ref (fun () -> assert false)

(******************************************************************************)

let () =
  let build_bc2c = Filename.concat (Filename.concat Config.builddir "bin") "bc2c" in
  try
    let build_stats = Unix.stat build_bc2c in
    let my_stats = Unix.stat Sys.argv.(0) in
    if build_stats.Unix.st_ino = my_stats.Unix.st_ino then local := true;
  with _ -> ()
  
(******************************************************************************)

let spec = [
  ("-o", Arg.String (fun o -> output_path := Some o),
   "<file.c> Set output file (default: <bytecode>.c)");
  ("-i", Arg.String (fun path -> lincludes := path :: !lincludes),
   "<file.c> Include this local file into the generated file (with #include \"...\")");
  ("-I", Arg.String (fun path -> gincludes := path :: !gincludes),
   "<file.c> Include this global file into the generated file (with #include <...>)");
  ("-stack-size", Arg.Set_int stack_size,
   Printf.sprintf "<word-nb> Set stack size (default: %d)" !stack_size);
  ("-heap-size", Arg.Set_int heap_size,
   Printf.sprintf "<word-nb> Set heap size (default: %d)" !heap_size);
  ("-gc", Arg.Set_string gc,
   Printf.sprintf "<gc-algo> Set garbage collector algorithm Stop&Copy or Mark&Compact (default: %s)" !gc);
  ("-arch", Arg.Int (fun n -> arch := Arch.of_int n),
   Printf.sprintf "<bit-nb> Set virtual machine architecture (default: %s)" (Arch.to_string !arch));
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
  else spec @ [ ("-local", Arg.Set local, " Use the OMicroB build directory instead of installation directory") ]

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

let gc =
  match String.uppercase_ascii !gc with
  | "SC" | "SAC" | "STOP_AND_COPY" | "STOP&COPY" -> `SAC
  | "MC" | "MAC" | "MARK_AND_COMPACT" | "MARK&COMPACT" -> `MAC
  | str -> usage_error (Printf.sprintf "invalid gc algorithm: %S" str)
    
let lib_dir = if local then [ Config.builddir; "src"; "byterun"; "vm" ] else [ Config.includedir; "vm" ]

let values_h  = List.fold_right Filename.concat lib_dir "values.h"
let runtime_c = List.fold_right Filename.concat lib_dir "runtime.c"

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
      let ooid, accu, stack, globals, code = Cleaner.clean bytefile.Bytefile.prim bytefile.Bytefile.data bytefile.Bytefile.code in
      let bytecode, opcodes, codemap = Codegen.export code in
      let accudata, stackdata, globdata, heapdata = Datagen.export arch codemap accu stack globals in
      let stackdata = Datagen.reverse_stack stack_size stackdata in

      let heap_available_size =
        match gc with
        | `SAC ->
          if heap_size mod 2 <> 0 then error (Printf.sprintf "heap size should be even when using a Stop&Copy GC algorithm");
          heap_size / 2
        | `MAC ->
          heap_size in
      if List.length heapdata > heap_available_size then (
        error (Printf.sprintf "too huge global data (%d words) for the defined heap size (%d words), out of memory before start" (List.length heapdata) heap_available_size);
      );

      (* Defined Constants *)
      Printf.fprintf oc "#define OCAML_STACK_WOSIZE         %8d\n" stack_size;
      Printf.fprintf oc "#define OCAML_HEAP_WOSIZE          %8d\n" heap_size;
      Printf.fprintf oc "#define OCAML_HEAP_INITIAL_WOSIZE  %8d\n" (List.length heapdata);
      Printf.fprintf oc "#define OCAML_STACK_INITIAL_WOSIZE %8d\n" (List.length stack);
      Printf.fprintf oc "#define OCAML_GLOBDATA_NUMBER      %8d\n" (List.length globdata);
      Printf.fprintf oc "#define OCAML_BYTECODE_BSIZE       %8d\n" (List.length bytecode);
      Printf.fprintf oc "#define OCAML_PRIMITIVE_NUMBER     %8d\n" (Array.length bytefile.Bytefile.prim);
      Printf.fprintf oc "#define OCAML_VIRTUAL_ARCH         %8s\n" (Arch.to_string arch);
      Printf.fprintf oc "#define OCAML_STARTING_OOID        %8d\n" ooid;
      Printf.fprintf oc "\n";

      (* Defined Variables *)
      Printf.fprintf oc "#define %s\n" (match gc with `SAC -> "OCAML_GC_STOP_AND_COPY" | `MAC -> "OCAML_GC_MARK_AND_COMPACT");
      if debug then Printf.fprintf oc "#define OCAML_DEBUG_MODE\n";
      Printf.fprintf oc "\n";

      (* Include values.h *)
      Printf.fprintf oc "#include <%s>\n" values_h;
      Printf.fprintf oc "\n";

      (* Define heap, acc, stack, global_data, bytecode *)
      Printer.print_opcodes oc opcodes;
      Printf.fprintf oc "\n";
      Printer.print_datagen_word_array oc "val_t" "ocaml_heap" "OCAML_HEAP_WOSIZE" heapdata;
      Printf.fprintf oc "\n";
      Printf.fprintf oc "val_t acc = %s;\n" (Printer.string_of_dword accudata);
      Printf.fprintf oc "\n";
      Printer.print_datagen_word_array oc "val_t" "ocaml_stack" "OCAML_STACK_WOSIZE" stackdata;
      Printf.fprintf oc "\n";
      Printer.print_datagen_word_array oc "val_t" "ocaml_global_data" "OCAML_GLOBDATA_NUMBER" globdata;
      Printf.fprintf oc "\n";
      Printer.print_codegen_word_array oc "PROGMEM opcode_t" "const ocaml_bytecode" "OCAML_BYTECODE_BSIZE" bytecode;
      Printf.fprintf oc "\n";

      (* Include runtime.c and extern files *)
      Printf.fprintf oc "#include <%s>\n" runtime_c;
      List.iter (Printf.fprintf oc "#include <%s>\n") !gincludes;
      List.iter (Printf.fprintf oc "#include \"%s\"\n") !lincludes;
      Printf.fprintf oc "\n";

      (* Define primitive table *)
      Printer.print_prim oc bytefile.Bytefile.prim;
    )
  with
  | Failure msg | Sys_error msg -> error msg
  | exn -> error (Printexc.to_string exn)

(******************************************************************************)
