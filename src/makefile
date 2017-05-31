all: poe

refai:	cclean poe
poe:	objs 
	ocamlc -o poe.exe entrada.cmo listas.cmo cadenaISO.cmo esquemas.cmo utiles.cmo main.cmo
 


objs: entrada.cmo listas.cmo  cadenaISO.cmo esquemas.cmo utiles.cmo main.cmo

esquemas.cmo: 	esquemas.ml
	ocamlc -c esquemas.ml

utiles.cmo:	utiles.ml
	ocamlc -c utiles.ml

main.cmo:	main.ml	
	ocamlc -c main.ml

listas.cmo:	listas.ml
	ocamlc -c listas.ml

cadenaISO.cmo:	cadenaISO.ml
	ocamlc -c cadenaISO.ml

entrada.cmo: 	entrada.ml
	ocamlc -c entrada.ml

poeexe: objexe 
	ocamlopt -verbose -o poe entrada.cmx listas.cmx cadenaISO.cmx esquemas.cmx utiles.cmx main.cmx

objexe:	entrada.cmx listas.cmx  cadenaISO.cmx esquemas.cmx utiles.cmx main.cmx

esquemas.cmx:	esquemas.ml
	ocamlopt -c esquemas.ml

utiles.cmx:	utiles.ml
	ocamlopt  -c utiles.ml

main.cmx:	main.ml
	ocamlopt -c main.ml

listas.cmx:	listas.ml
	ocamlopt -c listas.ml

cadenaISO.cmx:	cadenaISO.ml
	ocamlopt  -c cadenaISO.ml

entrada.cmx: entrada.ml
	ocamlopt -c entrada.ml

clean:
	del -f *.cmo *.cmi *.o core *.cmx

cclean:	clean
	del -f poe
