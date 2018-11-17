open Syncdf

let state_machine init transition input =
	let state = cell [%dfg (lift init)] in 
	state <~ [%dfg (lift transition) state input ]; 
	state 

let alt = state_machine 1 (fun s _ -> 1 - s) (lift 0)

let sum inp = 
  state_machine 0 (fun s i -> i + s) inp

let alt_sum = sum alt 

let print_i i = print_int i; print_newline()

let _ = step (); step (); step (); print_i (peek alt_sum) 