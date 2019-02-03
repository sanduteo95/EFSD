open Syncdf

let (+) = lift (+);;

peek ((fun x y -> [%dfg (x + x) + (y + y)]) (cell [%dfg 0]) (lift 2))