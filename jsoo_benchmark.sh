#!/bin/bash

# Only get the real time
TIMEFORMAT=%R

for i in benchmarks/*.ml; do
	NAME=$(basename $i .ml)
	# plain js
	ocamlfind ppx_tools/rewriter ./syncdf_ext.native $i > benchmark_build/js/$NAME.ml
	ocamlfind ocamlc -g -I lib/ -I lib/plain -w -10 -linkpkg -package js_of_ocaml,js_of_ocaml.ppx,js_of_ocaml-lwt -o benchmark_build/js/$NAME.bytes lib/heterolist.ml lib/plain/syncdf.ml benchmark_build/js/$NAME.ml
	js_of_ocaml --pretty --noinline benchmark_build/js/$NAME.bytes
	# inc js
	ocamlfind ppx_tools/rewriter ./syncdf_ext.native $i > benchmark_build/js/inc/$NAME.ml
	ocamlfind ocamlc -g -I lib/ -I lib/incremental -w -10 -linkpkg -package js_of_ocaml,js_of_ocaml.ppx,js_of_ocaml-lwt -o benchmark_build/js/inc/$NAME.bytes lib/heterolist.ml lib/incremental/syncdf.ml benchmark_build/js/inc/$NAME.ml
	js_of_ocaml --pretty --noinline benchmark_build/js/inc/$NAME.bytes ;
done 

########## benchmarks for cellular automata ##########
echo "\n########## cellular_automata ##########"
echo "---------- size 10, running 100 times"
echo "\nPlain:"
time node benchmark_build/js/cellular_automata.js 10 100
echo "\nInc:"
time node benchmark_build/js/inc/cellular_automata.js 10 100

########## benchmarks for incremental ##########
echo "\n########## incremental ##########"
echo "---------- with 100 nodes"
echo "\nPlain:"
time node benchmark_build/js/incremental.js 100
echo "\nInc:"
time node benchmark_build/js/inc/incremental.js 100

########## benchmarks for light control ##########
echo "\n########## light_control ##########"
echo "---------- with 100 commands"
echo "\nPlain:"
time node benchmark_build/js/light_control.js 100
echo "\nInc:"
time node benchmark_build/js/inc/light_control.js 100

########## benchmarks for planets ##########
echo "\n########## planets ##########"
echo "---------- with 10 planets, running 100 times"
echo "\nPlain:"
time node benchmark_build/js/planets.js 10 100
echo "\nInc:"
time node benchmark_build/js/inc/planets.js 10 100


