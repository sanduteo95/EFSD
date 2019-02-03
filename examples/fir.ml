open Syncdf

let (+.) = lift (+.)

let rec fir x = function
| [] -> (x, [%dfg 0.0])
| f :: fs -> let (out, sum) = fir x fs in
             let s = cell [%dfg 0.0] in 
             link s out;
             let f = lift f in 
             (s, [%dfg f s +. sum])

let w = fun x -> x /. 3.0

let avg3 x = 
  let (out, sum) = fir x [w; w; w] in 
  sum 

let input =  
  let s = cell [%dfg 0.0] in 
  link s [%dfg s +. 1.0];
  s

let out = avg3 input


let print_f f = print_float f; print_newline()

let _ = 
  step();
  step();
  step();
  print_f (peek out)