open Syncdf

let (+.) = lift (+.)

let rec fir x = function
| [] -> x
| f :: fs -> let (ins, outs) = fir x fs in
             let xout = List.nth outs 0 in
             let yout = List.nth outs 1 in
             let s    = cell [%dfg 0.0] in 
             link s xout;
             let f' = lift f in
             (ins, [xout; [%dfg s +. f' yout]])

let w = fun x -> x /. 3.0

let avg3 x = 
  let (ins, outs) = fir x [w; w; w] in
  (ins, [List.nth outs 1])

let input =  
  let s = cell [%dfg 0.0] in 
  link s [%dfg s +. 1.0];
  s

let (ins, outs) = avg3 ([input], [input;input]) 


let print_f f = print_float f; print_newline()

let _ = 
  print_f (peek (List.nth outs 0));
  step();
  print_f (peek (List.nth outs 0));
  step();
  print_f (peek (List.nth outs 0));
  step();
  print_f (peek (List.nth outs 0))