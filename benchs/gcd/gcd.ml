let gcd m n =
  let rec loop a b = 
    if a = b then a
    else if a < b then loop a (b-a)
    else loop (a-b) b in
  loop m n

let rec repeat n =
  if n <= 0 then () else (
    ignore (gcd 500001 500003);
    (repeat(n-1)))

let main () = 
  let r = repeat 20 in r;
;;

main() ;;
