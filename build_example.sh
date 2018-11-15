#!/bin/bash
if [ "$2" = "-i" -o "$2" = "-inc" ];
then
	if 
		ocamlfind ppx_tools/rewriter ./syncdf_ext.native examples/"$1".ml > example_build/"$1"_syncdf_inc.ml
		ocamlfind ocamlopt -I lib/ -I lib/incremental/ -w -10 -package lwt -o example_build/"$1"_inc.o lib/heterolist.ml lib/incremental/syncdf.ml example_build/"$1"_syncdf_inc.ml ;
	then
		echo "$1_syncdf_inc.ml\n$1_inc.o build!"
	fi
else
	if 
		ocamlfind ppx_tools/rewriter ./syncdf_ext.native examples/"$1".ml > example_build/"$1"_syncdf.ml
		ocamlfind ocamlopt -thread -I lib/ -I lib/plain -w -10 -linkpkg -package lwt,lwt.unix -o example_build/"$1".o lib/heterolist.ml lib/plain/syncdf.ml example_build/"$1"_syncdf.ml ;
	then 
		echo "$1_syncdf.ml\n$1.o build!"
	fi
fi