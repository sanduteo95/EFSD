open Heterolist

type 'a cell = ('a * 'a graph * 'a option) ref

and 'a graph = Val of 'a 
             | Fun of 'a
             | Thunk of (unit -> 'a)
             | IF_Thunk of (unit -> 'a graph)
             | Cell of 'a cell 

let lift t = Val t 

let lift_fun t = Fun t 

let rec peek g = 
  match g with
  | Val c -> c 
  | Fun f -> f
  | Thunk t -> t ()
  | IF_Thunk t -> peek (t ())
  | Cell x -> let (v,_,_) = !x in v 

let apply t u =
  match (t, u) with
  | Val t , Val u -> Val (t u) 
  | _             -> Thunk (fun () -> (peek t) (peek u)) 

let ifthenelse b t1 t2 =
  match b with
  | Val c -> if c then t1() else t2() 
  | _     -> let t1 = t1() in let t2 = t2() in IF_Thunk (fun () -> if peek b then t1 else t2)


let cells = ref (create())

(* constant *)
let cell g = 
  let c = ref (peek g, g, None) in
  cells := add !cells c; 
  Cell c

let init _ = 
  cells := create() 

(* linear *)
let step () = 
  fold 
    (fun _ x -> 
      match !x with
      | (v, g, None) -> x := (v, g, Some (peek g))
      | _            -> failwith "should be None" 
    ) () !cells; 
  fold 
    (fun b x -> 
      match !x with  
      | (v, g, Some w) -> x := (w, g, None); b || v != w
      | _              -> failwith "re-eval missing" 
    ) false !cells

(* constant *)
let rec link cell dep = 
  match cell with
  | Cell x -> let (v, _, _) = !x in x := (v, dep, None)
  | IF_Thunk t -> link (t()) dep
  | _ -> failwith "link: not a cell" 

(* constant *)
let rec set cell v =
  match cell with
  | Cell x -> x := (v, Val v, None)
  | IF_Thunk t -> set (t()) v
  | _ -> failwith "set: not a cell" 

let (<~) = link 

let (<<~) = set 
