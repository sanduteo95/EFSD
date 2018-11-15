open Heterolist

(* cell = current state, dependency, possible new value, childs *)
type 'a cell = ('a * 'a graph * 'a option * hlist) ref 

and 'a pgraph = Val of 'a 
             | Fun of 'a
             | Thunk of (unit -> 'a) 
             | IF_Thunk of (unit -> 'a graph) 
             | Cell of 'a cell 

(* graph, parents *)
and 'a graph = 'a pgraph * hlist 

let lift t = (Val t, create()) 

let lift_fun t = (Fun t, create())

let rec peek (g, l) = 
  match g with
  | Val c -> c 
  | Fun f -> f
  | Thunk t -> t ()
  | IF_Thunk t -> peek (t ())
  | Cell x -> let (v,_,_,_) = !x in v 

let apply ((t1, l1) as t) ((t2, l2) as u) =
  match (t1, t2) with
  | Val t, Val u -> Val (t u), create() 
  | _            -> Thunk (fun () -> (peek t) (peek u)), union l1 l2

let ifthenelse ((b, h) as cond) t1 t2 = 
  match b with
  | Val c -> if c then t1() else t2() 
  | _     -> let (t1, l1) as t = t1() in 
             let (t2, l2) as u = t2() in 
             IF_Thunk (fun () -> if peek cond then t else u), union (union h l1) l2

let cells = ref (create())

let rec addChildTo l c = 
  iter (fun x -> let (v, g, op, childs) = !x in x := (v, g, op, add_unique childs c)) l 

let rec removeChildFrom l c =
  iter (fun x -> let (v, g, op, childs) = !x in x := (v, g, op, remove childs c)) l 

let cell ((g, l) as t) = 
  let c = ref (peek t, (g, l), None, create()) in 
  addChildTo l c;
  (Cell c, add (create()) c) 

let init _ = 
  cells := create()

(* quadratic *)
let step () = 
  let dirty = fold 
    (fun dirty x -> 
      match !x with
      | (v, g, None, childs) -> let new_v = peek g in
                                x := (v, g, Some new_v, childs); 
                                if (v <> new_v) then append dirty childs (* currently linear, could be made constant by improving the list implementation*)
                                else dirty
      | _                    -> dirty 
    ) (create()) !cells 
  in 
  let result = fold 
    (fun acc x -> 
      match !x with
      | (v, g, Some w, childs) -> x := (w, g, None, childs); acc || (v != w)
      | _                      -> acc 
    ) false !cells 
  in 
  cells := dirty;
  result 

(* linear *)
let rec link (cell, _) (dep, h) = 
  match cell with
  | Cell x -> let (v, (g, l), _, childs) = !x in 
              x := (v, (dep, h), None, childs);
              removeChildFrom l x; 
              addChildTo h x; 
              cells := add_unique !cells x
  | IF_Thunk t -> link (t()) (dep, h) 
  | _ -> failwith "link: not a cell" 

(* linear *)
let rec set (cell, _) v = 
  match cell with
  | Cell x -> let (old_v, (g, l), _, childs) = !x in 
              removeChildFrom l x; 
              (if old_v <> v then cells := append !cells childs else ());
              x := (v, (Val v, create()), None, childs) 
  | IF_Thunk t -> set (t()) v
  | _ -> failwith "set: not a cell" 

let (<~) = link 

let (<<~) = set 
