all:
	ocamlbuild -package compiler-libs.common ppx/syncdf_ext.native
	ocamlc -c lib/heterolist.mli
	ocamlc -I lib/ -c lib/plain/syncdf.mli
	ocamlc -I lib/ -c lib/incremental/syncdf.mli
	mkdir example_build
	mkdir example_build/js
	mkdir benchmark_build
	mkdir benchmark_build/rml
	mkdir benchmark_build/inc
	mkdir benchmark_build/incjs
	mkdir benchmark_build/js
	mkdir benchmark_build/js/inc

clean:
	rm -rf _build/
	rm *.native
	rm -rf example_build/
	rm -rf benchmark_build/
	find lib/ -name "*.cmi" -type f -delete
	find lib/ -name "*.cmx" -type f -delete
	find lib/ -name "*.o" -type f -delete
