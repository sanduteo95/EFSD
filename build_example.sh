#!/bin/bash
# set the directory to script directory
cd "$(dirname "$0")"

if [ "$2" = "-i" -o "$2" = "-inc" ];
then
	if [ "$3" = "-js" ];
	then
		if
			ocamlfind ppx_tools/rewriter ./syncdf_ext.native examples/"$1".ml > example_build/js/"$1"_syncdf_inc.ml
			ocamlfind ocamlc -g -I lib/ -I lib/incremental -w -10 -linkpkg -package js_of_ocaml,js_of_ocaml.ppx,js_of_ocaml-lwt -o example_build/js/"$1"_inc.bytes lib/heterolist.ml lib/incremental/syncdf.ml example_build/js/"$1"_syncdf_inc.ml
			js_of_ocaml --pretty --noinline example_build/js/"$1".bytes ;
		then
			echo "js/$1_inc.js build!"
		fi
	else
		if 
			ocamlfind ppx_tools/rewriter ./syncdf_ext.native examples/"$1".ml > example_build/"$1"_syncdf_inc.ml
			ocamlfind ocamlopt -I lib/ -I lib/incremental/ -w -10 -package lwt -o example_build/"$1"_inc.o lib/heterolist.ml lib/incremental/syncdf.ml example_build/"$1"_syncdf_inc.ml ;
		then
			echo "$1_syncdf_inc.ml\n$1_inc.o build!"
		fi
	fi
else
	if [ "$2" = "-js" ];
	then
		if
			ocamlfind ppx_tools/rewriter ./syncdf_ext.native examples/"$1".ml > example_build/js/"$1"_syncdf.ml ;
			ocamlfind ocamlc -g -I lib/ -I lib/plain -w -10 -linkpkg -package js_of_ocaml,js_of_ocaml.ppx,js_of_ocaml-lwt -o example_build/js/"$1".bytes lib/heterolist.ml lib/plain/syncdf.ml example_build/js/"$1"_syncdf.ml
			js_of_ocaml --pretty --noinline example_build/js/"$1".bytes ;
		then
			echo "js/$1.js build!"
		fi
	else
		if
			ocamlfind ppx_tools/rewriter ./syncdf_ext.native examples/"$1".ml > example_build/"$1"_syncdf.ml ;
			ocamlfind ocamlopt -thread -I lib/ -I lib/plain -w -10 -linkpkg -package lwt,lwt.unix -o example_build/"$1".o lib/heterolist.ml lib/plain/syncdf.ml example_build/"$1"_syncdf.ml ;
		then 
			echo "$1_syncdf.ml\n$1.o build!"
		fi
	fi
fi