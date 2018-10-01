let () =
  trace "Hello"

class virtual node = object
  method virtual to_string : string
end

class bin_node (left : node) (right : node) = object(self)
  method left  = left
  method right = right
  method to_string = "(" ^ self#left#to_string ^ ", " ^ self#right#to_string ^ ")"
end

class leaf n = object
  method to_string = string_of_int n
end

let () =
  let l1 = new leaf 1 and l2 = new leaf 2 and l3 = new leaf 3 in
  let b1 = new bin_node (l1 :> node) (l2 :> node) in
  let b2 = new bin_node (b1 :> node) (l3 :> node) in
  let b3 = new bin_node (b1 :> node) (b2 :> node) in
  let str = b3#to_string in
  trace str
