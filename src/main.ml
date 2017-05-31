(****************************************************************************)
(*                                                                          *)
(*                                 AnMetriGal                               *)
(*                                                                          *)
(*     Análise de métrica en verso en lingua galega                         *)
(*                                                                          *)
(*   Copyright 2017 Julio J. Gómez Díaz                                     *)
(*                                                                          *)
(*                                                                          *)
(*   Licensed under the Apache License, Version 2.0 (the "License");        *)
(*   you may not use this file except in compliance with the License.       *)
(*   You may obtain a copy of the License at                                *)
(*                                                                          *)
(*      http://www.apache.org/licenses/LICENSE-2.0                          *)
(*                                                                          *)
(*   Unless required by applicable law or agreed to in writing, software    *)
(*   distributed under the License is distributed on an "AS IS" BASIS,      *)
(*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.*)
(*   See the License for the specific language governing permissions and    *)
(*   limitations under the License.                                         *)
(*                                                                          *)
(****************************************************************************)

(* ********************************************************************** *)
(*
   * Modulo principal del analizador
   *
   *
*)

open Arg;;
open Listas;;
open Entrada;;
open Utiles;;

let argumentos=Sys.argv;;

let _=
  (
   if ((Array.length argumentos) != 3)
   then
     (
      prerr_string("\n Uso:\n\tpoe <fich_entrada> <fich_salida>\n");
      exit 1
     )
  );;

let fentrada=argumentos.(1);;
let _ =
  (
   if (not (Sys.file_exists(fentrada)))
   then
     (
      prerr_string("\n Error: No existe fichero de entrada: "^fentrada^".\n");
	exit 2
     )
  )
      ;;



let lista_estrofas=separa_estrofas (haz_lista fentrada);;


let h_salida=open_out argumentos.(2);;

let rec recorre_estrofa listapares listaversos=
  match listapares with
    []         -> ()
  | (n,_)::l3  ->
      let verso=List.hd listaversos
      in
      (
       output_string h_salida (verso^"  \t"^(string_of_int n)^"\n");
       recorre_estrofa l3 (List.tl listaversos)
      )
	;;

let rec para_toda_estrofa l=
  match l with
    []      ->  ()
  | est::l1 ->
      let num_rima_lista=trata_estrofa est
      in
      (
       recorre_estrofa num_rima_lista est;
       let n=string_of_int (num_versos est)
       in
       output_string h_salida ("\nEstrofa de "^n^" versos.\n");
       let (nom,esq,rim)=identifica_estrofa num_rima_lista
       in
       (
	output_string h_salida ("É un/unha "^nom^".\n");
	output_string h_salida ("Esquema:  ");
	let rec imp_esq l5=
	  match l5 with
	    []    -> ""
	  | a1::b -> ((String.make 1 a1)^" ")^imp_esq b
	in
	let p=imp_esq esq
	in output_string h_salida (p^"\n");
	let rima=if rim="CO" then "consoante" else "asoante"
	in
	output_string h_salida ("Ten rima "^rima^".\n");
	output_string h_salida ("=================================\n\n");
       );

       para_toda_estrofa l1
      )
	;;



let _=para_toda_estrofa lista_estrofas ;;
let _=  output_string h_salida "\n\n";;
let _=close_out h_salida;;
let _=print_string("\nFicheiro analizado con éxito.\n");;
let _=exit 0;;

(* ************************************************************************ *)
