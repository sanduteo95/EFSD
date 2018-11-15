open Syncdf

let (+) = lift (+)

let signal =
	let s = cell [%dfg 1] in 
	link s [%dfg s + 1];
	s

let rsum i = 
	let s = cell [%dfg 0] in 
	link s [%dfg s + i];
	s

let o = rsum signal 


let print_i i = print_int i; print_newline()

let _ = 
	print_i (peek o);
	step();
	print_i (peek o);
	step();
	print_i (peek o);
	step();
	print_i (peek o);
	step();
	print_i (peek o);
	step();
	print_i (peek o);
	step();
	print_i (peek o);
	step();
	print_i (peek o);
	step();
	print_i (peek o)