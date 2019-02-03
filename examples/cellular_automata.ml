open Syncdf

type state = Zero | One

let get_neighbour i cell_array = 
	if i == 0 then (lift Zero, cell_array.(i), cell_array.(i+1))
	else if i == (Array.length cell_array) - 1 then (cell_array.(i-1), cell_array.(i), lift Zero)
	else (cell_array.(i-1), cell_array.(i), cell_array.(i+1))

let create_automata size init transition = 
	let cell_array = Array.init size (fun i -> cell (lift init.(i))) in 
	Array.iteri (fun i _ -> 
		let (a,b,c) = get_neighbour i cell_array in 
		link (cell_array.(i)) [%dfg (lift transition) a b c]
	) cell_array;
	cell_array

let rule110 a b c = 
	match (a,b,c) with
	| (One, One, One) -> Zero
	| (One, One, Zero) -> One
	| (One, Zero, One) -> One
	| (One, Zero, Zero) -> Zero
	| (Zero, One, One) -> One
	| (Zero, One, Zero) -> One
	| (Zero, Zero, One) -> One
	| (Zero, Zero, Zero) -> Zero

let rule54 a b c = 
	match (a,b,c) with
	| (One, One, One) -> Zero
	| (One, One, Zero) -> Zero
	| (One, Zero, One) -> One
	| (One, Zero, Zero) -> One
	| (Zero, One, One) -> Zero
	| (Zero, One, Zero) -> One
	| (Zero, Zero, One) -> One
	| (Zero, Zero, Zero) -> Zero

let _ =
	init();
	let size = int_of_string Sys.argv.(1) in 
	let total_step = int_of_string Sys.argv.(2) in 
	let _ = create_automata size (Array.init size (fun i -> if i == (size-1)/2 then One else Zero)) rule54 in 
	for i = 1 to total_step do
		step()
	done