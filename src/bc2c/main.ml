(******************************************************************************)

let stack_size       = ref 64
let total_heap_size  = ref 256
let gc               = ref "MAC"
let arch             = ref Arch.A32
let output_path      = ref None
let local            = ref false
let debug            = ref false
let verbose          = ref false
let no_clean_interp  = ref false
let no_shortcut_init = ref false
let no_flash_heap    = ref false
let no_flash_globals = ref false
let bytecode_path    = ref None
let lincludes        = ref []
let gincludes        = ref []
let rusage           = ref (fun () -> assert false)

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
  ("-heap-size", Arg.Set_int total_heap_size,
   Printf.sprintf "<word-nb> Set heap size (default: %d)" !total_heap_size);
  ("-gc", Arg.Set_string gc,
   Printf.sprintf "<gc-algo> Set garbage collector algorithm Stop&Copy or Mark&Compact (default: %s)" !gc);
  ("-arch", Arg.Int (fun n -> arch := Arch.of_int n),
   Printf.sprintf "<bit-nb> Set virtual machine architecture (default: %s)" (Arch.to_string !arch));

  ("-no-clean-interpreter", Arg.Set no_clean_interp,
   " Do not remove unused VM instructions, compile and link all of them");
  ("-no-shortcut-initialization", Arg.Set no_shortcut_init,
   " Do not improve starting time by evaluating the program initialization at compile time");
  ("-no-flash-heap", Arg.Set no_flash_heap,
   " Do not use flash to store immutable data from the heap known at compile time");
  ("-no-flash-globals", Arg.Set no_flash_globals,
   " Do not use flash to store immutable entries of the global data table");

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

let total_heap_size  = !total_heap_size
let stack_size       = !stack_size
let arch             = !arch
let local            = !local
let debug            = !debug
let no_clean_interp  = !no_clean_interp
let no_shortcut_init = !no_shortcut_init
let no_flash_heap    = !no_flash_heap
let no_flash_globals = !no_flash_globals

let () =
  if total_heap_size <= 0 then usage_error (Printf.sprintf "invalid heap size: %d" total_heap_size);
  if stack_size <= 0 then usage_error (Printf.sprintf "invalid stack size: %d" stack_size)

let gc =
  match String.uppercase_ascii !gc with
  | "SC" | "SAC" | "STOP_AND_COPY" | "STOP&COPY" -> `SAC
  | "MC" | "MAC" | "MARK_AND_COMPACT" | "MARK&COMPACT" -> `MAC
  | str -> usage_error (Printf.sprintf "invalid gc algorithm: %S" str)
    
let lib_dir = if local then [ Config.builddir; "src"; "byterun"; "vm" ] else [ Config.includedir; "vm" ]

let values_h     = List.fold_right Filename.concat lib_dir "values.h"
let runtime_c    = List.fold_right Filename.concat lib_dir "runtime.c"

(******************************************************************************)

let error msg =
  Printf.eprintf "Error: %s.\n%!" msg;
  (try Sys.remove output_path with _ -> ());
  exit 1

(******************************************************************************)

let () =
  try
    Tools.with_oc output_path (fun oc ->
      let bytefile = OByteLib.Bytefile.read bytecode_path in
      let ooid, accu, stack, globals, prims, code =
        if no_shortcut_init then 0, T.Int 0, [], Interp.import_globals bytefile.OByteLib.Bytefile.data, bytefile.OByteLib.Bytefile.prim, bytefile.OByteLib.Bytefile.code
        else Cleaner.clean arch bytefile.OByteLib.Bytefile.prim bytefile.OByteLib.Bytefile.data bytefile.OByteLib.Bytefile.code in
      let ram_globals, flash_globals, code = Datagen.split_globals no_flash_globals arch globals code in
      let bytecode, opcodes, codemap = Codegen.export code in
      let atom0, exceptions, accu_data, stack_data, ram_global_data, flash_global_data, static_heap_data, flash_heap_data = Datagen.export no_flash_heap arch codemap accu stack ram_globals flash_globals in

      let flash_heap_size = List.length flash_heap_data in
      let static_heap_size = List.length static_heap_data in
      let dynamic_heap_size =
        let sz = total_heap_size - static_heap_size in
        let sz = match gc with `SAC -> sz / 2 * 2 | `MAC -> sz in
        if sz < 0 then error (Printf.sprintf "too huge global data (%d words) for the defined heap size (%d words), out of memory before start" static_heap_size total_heap_size);
        sz in

      let opcodes = if no_clean_interp then Opcode.all else opcodes in
      
      (* Defined Constants *)
      Printf.fprintf oc "#define OCAML_STACK_WOSIZE          %8d\n" stack_size;
      Printf.fprintf oc "#define OCAML_STATIC_HEAP_WOSIZE    %8d\n" static_heap_size;
      Printf.fprintf oc "#define OCAML_DYNAMIC_HEAP_WOSIZE   %8d\n" dynamic_heap_size;
      Printf.fprintf oc "#define OCAML_FLASH_HEAP_WOSIZE     %8d\n" flash_heap_size;
      Printf.fprintf oc "#define OCAML_STACK_INITIAL_WOSIZE  %8d\n" (List.length stack);
      Printf.fprintf oc "#define OCAML_RAM_GLOBDATA_NUMBER   %8d\n" (List.length ram_global_data);
      Printf.fprintf oc "#define OCAML_FLASH_GLOBDATA_NUMBER %8d\n" (List.length flash_global_data);
      Printf.fprintf oc "#define OCAML_BYTECODE_BSIZE        %8d\n" (List.length bytecode);
      Printf.fprintf oc "#define OCAML_PRIMITIVE_NUMBER      %8d\n" (Array.length prims);
      Printf.fprintf oc "#define OCAML_VIRTUAL_ARCH          %8s\n" (Arch.to_string arch);
      Printf.fprintf oc "#define OCAML_STARTING_OOID         %8d\n" ooid;
      Printf.fprintf oc "#define OCAML_NO_FLASH_HEAP         %8d\n" (if no_flash_heap then 1 else 0);
      Printf.fprintf oc "#define OCAML_NO_FLASH_GLOBALS      %8d\n" (if no_flash_globals then 1 else 0);
      Printf.fprintf oc "\n";

      (* Defined Variables *)
      Printf.fprintf oc "#define %s\n" (match gc with `SAC -> "OCAML_GC_STOP_AND_COPY" | `MAC -> "OCAML_GC_MARK_AND_COMPACT");
      if debug then Printf.fprintf oc "#define OCAML_DEBUG_MODE\n";
      Printf.fprintf oc "\n";

      (* Include values.h *)
      Printf.fprintf oc "#include <%s>\n" values_h;
      Printf.fprintf oc "\n";

      (* Define opcodes *)
      Printer.print_opcodes oc opcodes;
      Printf.fprintf oc "\n";

      (* Declare heap variables *)
      Printf.fprintf oc "value ocaml_stack[OCAML_STACK_WOSIZE];\n";
      Printf.fprintf oc "value ocaml_ram_heap[OCAML_STATIC_HEAP_WOSIZE + OCAML_DYNAMIC_HEAP_WOSIZE];\n";
      if no_flash_globals then (
        Printf.fprintf oc "\n";
        Printer.print_datagen_word_array oc "value" "ocaml_ram_global_data" "OCAML_RAM_GLOBDATA_NUMBER" ram_global_data;
      ) else (
        assert (List.for_all ((=) (T.INT 0)) ram_global_data);
        Printf.fprintf oc "value ocaml_ram_global_data[OCAML_RAM_GLOBDATA_NUMBER];\n";
      );
      Printf.fprintf oc "\n";

      (* Define initial heaps, intial stack and initial global data *)
      Printer.print_datagen_word_array oc "PROGMEM value const" "ocaml_flash_heap" "OCAML_FLASH_HEAP_WOSIZE" flash_heap_data;
      Printf.fprintf oc "\n";
      Printer.print_datagen_word_array oc "PROGMEM value const" "ocaml_initial_static_heap" "OCAML_STATIC_HEAP_WOSIZE" static_heap_data;
      Printf.fprintf oc "\n";
      Printer.print_datagen_word_array oc "PROGMEM value const" "ocaml_initial_stack" "OCAML_STACK_INITIAL_WOSIZE" stack_data;
      Printf.fprintf oc "\n";
      Printer.print_datagen_word_array oc "PROGMEM value const" "ocaml_flash_global_data" "OCAML_FLASH_GLOBDATA_NUMBER" flash_global_data;
      Printf.fprintf oc "\n";

      (* Define acc and env *)
      Printf.fprintf oc "value acc = %s;\n" (Printer.string_of_dword accu_data);
      Printf.fprintf oc "value env = Val_unit;\n";
      Printf.fprintf oc "\n";

      (* Define exceptions *)
      List.iter (fun (exn_name, exn_data) ->
        Printf.fprintf oc "#define OCAML_%-20s %s\n" exn_name (Printer.string_of_dword exn_data);
      ) exceptions;
      Printf.fprintf oc "\n";

      (* Define atom0 *)
      Printf.fprintf oc "#define OCAML_%-20s %s\n" "atom0" (Printer.string_of_dword atom0);
      Printf.fprintf oc "\n";
      
      (* Define bytecode *)
      Printer.print_codegen_word_array oc "PROGMEM opcode_t const" "ocaml_bytecode" "OCAML_BYTECODE_BSIZE" bytecode;
      Printf.fprintf oc "\n";

      (* Include runtime.c and extern files *)
      Printf.fprintf oc "#include <%s>\n" runtime_c;
      List.iter (Printf.fprintf oc "#include <%s>\n") !gincludes;
      List.iter (Printf.fprintf oc "#include \"%s\"\n") !lincludes;
      Printf.fprintf oc "\n";

      (* Define primitive table *)
      Printer.print_prim oc prims;
    )
  with
  | Failure msg | Sys_error msg -> error msg
  | exn -> error (Printexc.to_string exn)

(******************************************************************************)
