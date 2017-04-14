open OByteLib

let () =
  let bytefile = Bytefile.read "/tmp/test.byte" in
  let bytecode = Export.export_code bytefile.Bytefile.code in
  let (globdata, _gdlen) = Export.export_data bytefile.Bytefile.data in
  Printer.print_data stdout "PROGMEM opcode_t" "bytecode" bytecode;
  Printer.print_data stdout "PROGMEM uint8_t" "globdata" globdata;
