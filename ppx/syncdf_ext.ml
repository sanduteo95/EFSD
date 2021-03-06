open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open List

open Syncdf_trans

let rec expr_mapper mapper expr = 
  match expr with
  | { pexp_desc =
      Pexp_extension ({ txt = tag; loc }, pstr) } -> 
    if List.mem tag ["dfg"] then root_translater tag loc pstr
    else default_mapper.expr mapper expr
  (* Delegate to the default mapper. *) 
  | _ -> default_mapper.expr mapper expr 


and pattern_mapper mapper pattern = 
  match pattern with
  | x -> default_mapper.pat mapper x 

and sacml_mapper argv =
  { 
    default_mapper with
    expr = expr_mapper;
    pat = pattern_mapper
  }
 
let () = register "syncdf_ext" sacml_mapper