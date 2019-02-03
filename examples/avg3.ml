open Syncdf

let (+.) = lift (+.)

let fir3 f x =
  let s0 = cell [%dfg 0.0] in
  let s1 = cell [%dfg 0.0] in
  let s2 = cell [%dfg 0.0] in
  link s0 x;
  link s1 s0;
  link s2 s1;
  let f = lift f in
  [%dfg (f 0 s0) +. (f 1 s1) +. (f 2 s2)] 

let input = 
  let s = cell [%dfg 0.0] in
  link s [%dfg s +. 1.0];
  s 

let avg3 = fir3 (fun _ x -> x /. 3.0) input

let print_f f = print_float f; print_newline()

let _ = 
	step();
	step();
	step();
	print_f (peek avg3)