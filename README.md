# Dependencies
In order to compile correctly, please make sure you have the following installed:

1. Ocaml, version 4.05.1
2. Ocamlfind 
3. ppx_tools

In order to run the benchmars, you will also need the following installed:

1. rml
2. incremental 

For example, if you are using `opam` then you can simply run `opam install rml`. 

# How to install
Simply run `make` to install the library and `make clean` to uninstall. 

# How to compile with EFSD
Since this is a proof-of-concept implementation, we simply use a bash program to help with compilation. Write you favourite program (say `prog.ml` and put it inside the `examples` directory. Run `sh build_example.sh prog` from the main directory. An executable will be produced in `example_build/prog.o`. Run `example_build/prog.o` to execute the program. 

As for the benchmarks, simply run `sh run_benchmarks.sh`. 
