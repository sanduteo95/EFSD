open Syncdf

let not' = lift not

let alt = 
  let s = cell [%dfg true] in
  link s [%dfg (not' s)];
  s

let print_bool b = print_endline (if b then "true" else "false")

let _ =
	print_bool (peek alt);
	step(); 
	print_bool (peek alt);
	step(); 
	print_bool (peek alt);
	step(); 
	print_bool (peek alt) 