let millis () = int_of_float (Unix.gettimeofday () *. 1000.)

module Serial = struct
  let write_string = print_string
  let write_int = print_int
end

module Screen = struct
  let set_pixel _ _ _ = ()
end
