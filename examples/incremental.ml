open Syncdf

let (+) = lift (+) 

let createCells n = 
	let input = cell [%dfg 0] in
	let rec aux n x = 
		match n with 
		| 0 -> x
		| n -> let c = cell [%dfg x + 1] in aux (n - 1) c 
	in 
	let _ = aux (n - 1) input in
	input 

let rec stabilise () =
	if step() then stabilise () else () 

let _ = 
	let n = int_of_string Sys.argv.(1) in 
	let x = createCells n in 
	set x 1; 
	stabilise()
