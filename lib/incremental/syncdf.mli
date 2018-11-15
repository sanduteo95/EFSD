open Heterolist

type 'a cell
type 'a graph
val lift : 'a -> 'a graph
val lift_fun : 'a -> 'a graph
val peek : 'a graph -> 'a
val apply : ('a -> 'b) graph -> 'a graph -> 'b graph
val ifthenelse : bool graph -> (unit -> 'a graph) -> (unit -> 'a graph) -> 'a graph
val cell : 'a graph -> 'a graph
val init : unit -> unit
val step : unit -> bool
val link : 'a graph -> 'a graph -> unit
val set : 'a graph -> 'a -> unit
val (<~) : 'a graph -> 'a graph -> unit
val (<<~) : 'a graph -> 'a -> unit