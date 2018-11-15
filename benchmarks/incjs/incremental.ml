module Inc = Incremental_lib.Incremental.Make ()
open Inc

let createGraph n = 
	let input_v = Var.create 0 in 
	let input = Var.watch input_v in 
	let rec aux n x = 
		match n with 
		| 0 -> x
		| n -> let c = Inc.map x ~f:(fun x -> x + 1) in aux (n - 1) c 
	in 
	let _ = aux (n - 1) input in
	input_v

let _ =
	let n = int_of_string Sys.argv.(1) in 
	let input_v = createGraph n in 
	Var.set input_v 1;
	Inc.stabilize ()