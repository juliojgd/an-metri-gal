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

(* ******************************************************************* *)

(*
   * Funciones de entrada para leer el poema de un fichero de texto.
   *
   *
   *
*)
let fin nomfich=
  try
    open_in nomfich
  with
    Sys_error (er) ->
      (
       prerr_endline ("ERROR: Al abrir "^nomfich^" "^er);
       exit 1
      );;

let linea fich=
  try
    input_line fich
  with
    End_of_file -> "FINFICH";;

let haz_lista st=
  let f=fin st
  in
  let rec aux a=
    (
     let t=linea f
     in
     if (t="FINFICH")
     then
       (
	close_in f;
	[]
       )
     else t::(aux a)
    )
  in
  aux 0;;
