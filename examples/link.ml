open Syncdf

let (+) = lift (+);;

let c =  cell [%dfg 0];;

let _ = ((fun x y -> [%dfg (x + x) + (y + y)]) (cell [%dfg 0]) (lift 2));;

link c (cell [%dfg 1])