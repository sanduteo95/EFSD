type hlist = int list

(* constant *)
let create _ = [] 

(* constant *)
let is_empty l = Obj.is_int (Obj.repr l)

(* constant *)
let add l v = 
	let ptr = Obj.new_block 0 2 in
	Obj.set_field ptr 0 (Obj.repr v);
	Obj.set_field ptr 1 (Obj.repr l);
	Obj.obj ptr

(* linear *)
let add_unique l v = 
	let l_rep = Obj.repr l in
	let rec add_aux curr =
		if Obj.is_int curr then
			add l v
		else
			let x = Obj.obj (Obj.field curr 0) in
			if v == x then l else add_aux (Obj.field curr 1)
	in
	add_aux l_rep

(* linear *)
let remove l v = 
	let l_rep = Obj.repr l in
	let rec remove_aux curr =
		if Obj.is_int curr then
			l
		else
			let x = Obj.obj (Obj.field curr 0) in
			if v == x 
			then (let next = Obj.field curr 1 in
				Obj.set_field curr 0 (Obj.field next 0);
				Obj.set_field curr 1 (Obj.field next 1);
				remove_aux curr)
			else remove_aux (Obj.field curr 1) 
	in
	remove_aux l_rep 

(* linear *)
let rec fold f b l = 
	let l_rep = Obj.repr l in
	let rec fold_aux b curr =
		if Obj.is_int curr then
			b
		else
			let x = Obj.obj (Obj.field curr 0) in
			fold_aux (f b x) (Obj.field curr 1)
	in
	fold_aux b l_rep

(* linear *)
let iter f l = fold (fun acc b -> f b) () l

(* linear *)
let length l = fold (fun acc b -> acc + 1) 0 l

(* quadratic *)
let union l1 l2 = fold (fun acc b -> add_unique acc b) l1 l2 

(* linear *)
let append l1 l2 = fold (fun acc b -> add acc b) l1 l2 