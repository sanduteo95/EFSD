#!/bin/bash

for i in benchmarks/*.ml; do
	NAME=$(basename $i .ml)
	ocamlfind ppx_tools/rewriter ./syncdf_ext.native $i > benchmark_build/$NAME.ml 
	ocamlfind ocamlopt -I lib/ -I lib/plain -w -10 -o benchmark_build/$NAME.o lib/heterolist.ml lib/plain/syncdf.ml benchmark_build/$NAME.ml ;
	ocamlfind ppx_tools/rewriter ./syncdf_ext.native $i > benchmark_build/inc/$NAME.ml 
	ocamlfind ocamlopt -I lib/ -I lib/incremental -w -10 -o benchmark_build/inc/$NAME.o lib/heterolist.ml lib/incremental/syncdf.ml benchmark_build/inc/$NAME.ml
done 

for i in benchmarks/rml/*.rml; do 
	NAME=$(basename $i .rml)
	rmlc $i -d benchmark_build/rml/
	ocamlfind ocamlopt -o benchmark_build/rml/$NAME -I `rmlc -where` unix.cmxa rmllib.cmxa benchmark_build/rml/$NAME.ml
done 

for i in benchmarks/incjs/*.ml; do 
	NAME=$(basename $i .ml)
	cp $i benchmark_build/incjs/$NAME.ml 
	ocamlfind ocamlopt -thread -linkpkg -package incremental -o benchmark_build/incjs/$NAME benchmark_build/incjs/$NAME.ml
done 

########## benchmarks for cellular automata ##########
echo "\n########## benchmarks for cellular automata ##########"
echo "---------- size 10, running 100 times"
echo "RML:"
time benchmark_build/rml/cellular_automata 10 100
echo "\nPlain EFSD:"
time benchmark_build/cellular_automata.o 10 100
echo "\nInc EFSD:"
time benchmark_build/inc/cellular_automata.o 10 100
echo "\n---------- size 100, running 100 times"
echo "RML:"
time benchmark_build/rml/cellular_automata 100 100
echo "\nPlain EFSD:"
time benchmark_build/cellular_automata.o 100 100
echo "\nInc EFSD:"
time benchmark_build/inc/cellular_automata.o 100 100
echo "\n---------- size 1000, running 100 times"
echo "RML:"
time benchmark_build/rml/cellular_automata 1000 100
echo "\nPlain EFSD:"
time benchmark_build/cellular_automata.o 1000 100
echo "\nInc EFSD:"
time benchmark_build/inc/cellular_automata.o 1000 100


########## benchmarks for incremental ##########
echo "\n########## benchmarks for incremental ##########"
echo "---------- with 1000 nodes"
echo "Incr Library:"
time benchmark_build/incjs/incremental 1000
echo "\nPlain EFSD:"
time benchmark_build/incremental.o 1000
echo "\nInc EFSD:"
time benchmark_build/inc/incremental.o 1000
echo "\n---------- with 10000 nodes"
echo "Incr Library:"
time benchmark_build/incjs/incremental 10000
echo "\nPlain EFSD:"
time benchmark_build/incremental.o 10000
echo "\nInc EFSD:"
time benchmark_build/inc/incremental.o 10000
echo "\n---------- with 100000 nodes"
echo "Incr Library:"
time benchmark_build/incjs/incremental 100000
echo "\nInc EFSD:"
time benchmark_build/inc/incremental.o 100000
echo "\n---------- with 1000000 nodes"
echo "Incr Library:"
time benchmark_build/incjs/incremental 1000000
echo "\nInc EFSD:"
time benchmark_build/inc/incremental.o 1000000
echo "\n---------- with 10000000 nodes"
echo "Incr Library:"
time benchmark_build/incjs/incremental 10000000
echo "\nInc EFSD:"
time benchmark_build/inc/incremental.o 10000000


########## benchmarks for light control ##########
echo "\n########## benchmarks for light control ##########"
echo "---------- with 100000 commands"
echo "RML:"
time benchmark_build/rml/light_control 100000 
echo "\nPlain EFSD:"
time benchmark_build/light_control.o 100000
echo "\nInc EFSD:"
time benchmark_build/inc/light_control.o 100000
echo "---------- with 1000000 commands"
echo "RML:"
time benchmark_build/rml/light_control 1000000
echo "\nPlain EFSD:"
time benchmark_build/light_control.o 1000000
echo "\nInc EFSD:"
time benchmark_build/inc/light_control.o 1000000
echo "---------- with 10000000 commands"
echo "RML:"
time benchmark_build/rml/light_control 10000000
echo "\nPlain EFSD:"
time benchmark_build/light_control.o 10000000
echo "\nInc EFSD:"
time benchmark_build/inc/light_control.o 10000000


########## benchmarks for planets ##########
echo "\n########## benchmarks for planets ##########"
echo "---------- with 10 planets, running 10000 times"
echo "RML:"
time benchmark_build/rml/planets 10 10000
echo "\nPlain EFSD:"
time benchmark_build/planets.o 10 10000
echo "\nInc EFSD:"
time benchmark_build/inc/planets.o 10 10000
echo "---------- with 10 planets, running 100000 times" 
echo "RML:"
time benchmark_build/rml/planets 10 100000
echo "\nPlain EFSD:"
time benchmark_build/planets.o 10 100000
echo "\nInc EFSD:"
time benchmark_build/inc/planets.o 10 100000
echo "\n---------- with 100 planets, running 10000 times"
echo "RML:"
time benchmark_build/rml/planets 100 10000
echo "\nPlain EFSD:"
time benchmark_build/planets.o 100 10000
echo "\nInc EFSD:"
time benchmark_build/inc/planets.o 100 10000
echo "\n---------- with 100 planets, running 100000 times"
echo "RML:"
time benchmark_build/rml/planets 100 100000
echo "\nPlain EFSD:"
time benchmark_build/planets.o 100 100000
echo "\nInc EFSD:"
time benchmark_build/inc/planets.o 100 100000



