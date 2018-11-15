open Syncdf


let create_transducer init input transition outF = 
	let state = cell [%dfg (lift init)] in 
	Syncdf.link state [%dfg (lift transition) state input];  
	(input, [%dfg (lift outF) state]) 


type alarm = Idle | Armed | Ring

type command = Arm | Off | Snooze | Bip

let bip() = for i = 1 to 4 do print_string "Bip " done 

open Lwt

let rec display_thread (input, out) = ( fun () -> 
	return (print_int 3) >>= fun () -> 
	(*Lwt_unix.sleep 1.0 >>= fun () -> *)
	return (print_int 4;step()) >>= fun _ -> 
	(match peek out with
	| Ring  -> return (bip(); print_newline()) 
	| Armed -> Lwt_unix.sleep 3.0 >>= fun () -> return (set input Bip)
	| _     -> return ()) >>= fun () -> 
	display_thread (input, out) ()
) 

let transition state input = 
	match (state, input) with
	| Idle, Arm    -> Armed
	| Armed, Bip   -> Ring
	| Armed, Off   -> Idle
	| Ring, Snooze -> Armed
	| Ring, Off	   -> Idle
	| s, _ 		   -> s 

let _ =
	init(); 
	let input = cell (lift Off) in 
	let alarm_clock = create_transducer Idle input transition (fun x -> x) in 
	let _ = Lwt.async (display_thread alarm_clock) in 
	while true do 
		let cmd = read_line() in 
		match cmd with
		| "arm" -> set input Arm
		| "off" -> set input Off 
		| "snooze" -> set input Snooze
		| _ -> print_endline "Wrong command. "
	done

