open OByteLib

let () =
  let bytefile = Bytefile.read "/tmp/test.byte" in
  Bytefile.print stdout bytefile
