open Pic32




class cell a =
  object
    val mutable v = (a : bool)
    method isAlive = v
  end ;;


(* 4.2 *)

class virtual absWorld n m  =
  object(self)
    val mutable tcell = Array.create_matrix n m (new cell false)
    val maxx = n
    val maxy = m
    val mutable gen = 0
    method private dessine(c) =
     (* if c#isAlive then print_string "*"
     else print_string "." *)
     if c#isAlive then digital_write PIN78 HIGH
     else digital_write PIN82 HIGH
    method display() =
      for i = 0 to (maxx-1) do
        for j=0 to (maxy -1) do
          (* print_string " " ;  *)
          self#dessine(tcell.(i).(j))
        done ;
        (* print_newline() *)
      done
    method getCell(i,j) = tcell.(i).(j)
    method setCell(i,j,c) = tcell.(i).(j) <- c
    method getCells = tcell
  end ;;


(* 4.3 *)

class world n m =
  object(self)
    inherit absWorld n m
    method neighbors(x,y) =
      let r = ref 0 in
      for i=x-1 to x+1 do
        let k = (i+maxx) mod maxx in
        for j=y-1 to y+1 do
          let l = (j + maxy) mod maxy in
            if tcell.(k).(l)#isAlive then incr r
        done
      done;
      if tcell.(x).(y)#isAlive then decr r ;
      !r

    method nextGen() =
      let w2 = new world maxx maxy in
      for i=0 to maxx-1 do
        for j=0 to maxy -1 do
          let n = self#neighbors(i,j) in
          if tcell.(i).(j)#isAlive   
          then (if (n = 2) || (n = 3) then w2#setCell(i,j,new cell true))
          else (if n = 3 then w2#setCell(i,j,new cell true))
        done
      done ;
      tcell <- w2#getCells ;
      gen <- gen + 1
  end ;;


(* 4.4 *)

exception Fin;;

let main () =
  pin_mode PIN78 OUTPUT;
pin_mode PIN82 OUTPUT;
  let a = 10 and b = 12 in
  let w = new world a b in
  w#setCell(4,4,new cell true) ;
  w#setCell(4,5,new cell true) ;
  w#setCell(4,6,new cell true) ;
  try 
    while true do
      w#display() ;
      (* if ((read_line()) = "F") then raise Fin else w#nextGen() *)
      w#nextGen() ;
    done 
  with Fin -> () ;;

main () ;;



