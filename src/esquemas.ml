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
   * En este fichero est�n contenidos los esquemas de las estrofas cl�sicas
   * reconocidas.
   *
*)

(* ********************************************************************** *)
let tablaEsquemas=Hashtbl.create 5;;

let _=Hashtbl.add tablaEsquemas 1 [("Verso libre",['a'],"CO");("Verso libre",['A'],"CO")];;
let _=Hashtbl.add tablaEsquemas 2 [("Pareado", ['a';'a'],"CO");("Pareado",['A';'A'],"CO")];;
let _=Hashtbl.add tablaEsquemas 3 [("Terceto",['A';'-';'A'],"CO");("Sole�",['a';'-';'a'],"AS")];;
let _=Hashtbl.add tablaEsquemas 4 [("Cuarteto",['A';'B';'B';'A'],"CO");
				    ("Redondilla",['a';'b';'b';'a'],"CO");
				    ("Serventesio",['A';'B';'A';'B'],"CO");
				    ("Cuarteta",['a';'b';'a';'b'],"CO");
				    ("Copla",['-';'a';'-';'a'],"AS");
				    ("Cuaderna v�a",['A';'A';'A';'A'],"CO")
				  ] ;;

let _=Hashtbl.add tablaEsquemas 5 [("Quinteto",['A';'B';'A';'B';'A'],"CO");
				    ("Quinteto",['A';'A';'B';'A';'B'],"CO");
				    ("Quinteto",['A';'B';'A';'A';'B'],"CO");
				    ("Quintilla",['a';'b';'a';'b';'a'],"CO");
				    ("Quintilla",['a';'a';'b';'a';'b'],"CO");
				    ("Quintilla",['a';'b';'a';'a';'b'],"CO");
				    ("Lira",['a';'B';'a';'b';'B'],"CO")
				  ];;

let _=Hashtbl.add tablaEsquemas 6 [("Copla manrique�a",['a';'b';'c';'a';'b';'c'],"CO")];;

let _=Hashtbl.add tablaEsquemas 8 [("Copla arte maior",['A';'B';'B';'A';'A';'C';'C';'A'],"CO");
				    ("Octava real",['A';'B';'A';'B';'A';'B';'C';'C'],"CO");
				    ("Octava italiana",['-';'A';'A';'B';'-';'C';'C';'B'],"CO");
				    ("Octavilla",['-';'a';'a';'b';'-';'c';'c';'b'],"CO")
				  ] ;;


let _=Hashtbl.add tablaEsquemas 10 [("D�cima",['a';'b';'b';'a';'a';'c';'c';'d';'d';'c'],"CO")];;

let _=Hashtbl.add tablaEsquemas 14 [
  ("Soneto",['A';'B';'B';'A';'A';'B';'B';'A';'A';'B';'A';'A';'B';'A'],"CO");
  ("Soneto",['A';'B';'B';'A';'C';'D';'D';'C';'A';'B';'A';'A';'B';'A'],"CO");
    ("Soneto",['A';'B';'B';'A';'C';'D';'D';'C';'A';'B';'A';'B';'A';'B'],"CO");
  ("Soneto",['A';'B';'A';'B';'C';'D';'C';'D';'A';'B';'A';'B';'A';'B'],"CO")
];;
