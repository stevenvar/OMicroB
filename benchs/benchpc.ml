let rec read_all_lines chan =
  try
    let l = input_line chan in
    l::read_all_lines chan
  with End_of_file -> []

let run_for_output cmd =
  let chan = Unix.open_process_in cmd in
  let output = read_all_lines chan in
  close_in chan;
  output

let run_for_error cmd =
  let (outchan, inchan, errchan) = Unix.open_process_full cmd [||] in
  let output = read_all_lines errchan in
  close_in outchan;
  close_out inchan;
  close_in errchan;
  output

let rec last = function
  | [x] -> x
  | _::tl -> last tl
  | _ -> invalid_arg "last"

let run_for_time outchan cmd =
  let cmd = Printf.sprintf "/usr/bin/time -f %%U %s > /dev/null" cmd in
  try
    let msg = run_for_error cmd in
    let s = float_of_string (List.hd msg) in
    output_string outchan (Printf.sprintf ",%fs" s)
  with _ -> output_string outchan ",N/A"

let run_for_size outchan cmd =
  let s = last (run_for_output cmd) in
  let texts = String.trim (List.hd (String.split_on_char '\t' s)) in
  output_string outchan (Printf.sprintf ",%so" texts)

let arm_size_cmd f =
  Printf.sprintf "arm-none-eabi-size %s" f

let avr_size_cmd f =
  Printf.sprintf "avr-size %s" f

let main outchan bench =
  Printf.printf "Running benchs for %s\n%!" bench;
  output_string outchan bench;

  let omicrob_cmd = Printf.sprintf "./%s.omicrob.byte" bench in
  Printf.printf "Running omicrob bench: %s\n%!" omicrob_cmd;
  run_for_time outchan omicrob_cmd;

  let ocamlrun_cmd = Printf.sprintf "./%s.ocamlrun.byte" bench in
  Printf.printf "Running ocamlrun bench: %s\n%!" ocamlrun_cmd;
  run_for_time outchan ocamlrun_cmd;

  let c_exe_cmd = Printf.sprintf "./%s-c.exe" bench in
  Printf.printf "Running C bench: %s\n%!" c_exe_cmd;
  run_for_time outchan c_exe_cmd;

  let python_cmd = Printf.sprintf "python3 %s.py" bench in
  Printf.printf "Running Python bench: %s\n%!" python_cmd;
  run_for_time outchan python_cmd;

  let c_arm_size_cmd = arm_size_cmd (Printf.sprintf "%s-c.arm_elf" bench) in
  Printf.printf "Getting C arm size: %s\n%!" c_arm_size_cmd;
  run_for_size outchan c_arm_size_cmd;

  let omicrob_arm_size_cmd = arm_size_cmd (Printf.sprintf "%s.arm_elf" bench) in
  Printf.printf "Getting OMicroB arm size: %s\n%!" omicrob_arm_size_cmd;
  run_for_size outchan omicrob_arm_size_cmd;

  (* let c_avr_size_cmd = avr_size_cmd (Printf.sprintf "%s-c.avr_elf" bench) in *)
  (* Printf.printf "Getting C avr size: %s\n" c_avr_size_cmd; *)
  (* run_for_size outchan c_avr_size_cmd; *)

  (* let omicrob_avr_size_cmd = avr_size_cmd (Printf.sprintf "%s.avr" bench) in *)
  (* Printf.printf "Getting OMicroB avr size: %s\n" omicrob_avr_size_cmd; *)
  (* run_for_size outchan omicrob_avr_size_cmd; *)

  output_string outchan "\n"

let outfile = "benchs-pc.csv"

let _ =
  let outchan = open_out outfile in
  output_string outchan
    "name,time-PC/omicrob,time-PC/ocamlrun,time-PC/C,\
     ,size-arm/C,size-arm/omicrob\n";

  Arg.parse [] (main outchan) "usage: ./benchpc.native <benchs>";

  close_out outchan
