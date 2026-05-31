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
   * Módulo principal del analizador
   *
   *
*)
open Lib.Entrada
open Lib.Utiles

let print_usage_and_exit () =
  prerr_string "\n Usage:\n\tanmetrigal <input_file> <output_file>\n";
  exit 1
;;

let validate_input_file input_file =
  if not (Sys.file_exists input_file) then (
    prerr_string ("\n Error: No existe fichero de entrada: " ^ input_file ^ ".\n");
    exit 2)
;;

let output_verse out_channel verse (num_silabas, _) =
  output_string out_channel (verse ^ "  \t" ^ string_of_int num_silabas ^ "\n")
;;

let format_esquema esquema =
  esquema
  |> List.map (String.make 1)
  |> String.concat " "
;;

let print_estrofa_result out_channel versos =
  let num_rima_lista = trata_estrofa versos in
  List.iter2 (output_verse out_channel) versos num_rima_lista;
  output_string out_channel ("\nEstrofa de " ^ string_of_int (num_versos versos) ^ " versos.\n");
  let nom, esq, rim = identifica_estrofa num_rima_lista in
  output_string out_channel ("É un/unha " ^ nom ^ ".\n");
  output_string out_channel ("Esquema:  " ^ format_esquema esq ^ "\n");
  let rima = if rim = "CO" then "consoante" else "asoante" in
  output_string out_channel ("Ten rima " ^ rima ^ ".\n");
  output_string out_channel "=================================\n\n"
;;

let analyze_file input_file output_file =
  let lista_estrofas = separa_estrofas (haz_lista input_file) in
  let out_channel = open_out output_file in
  List.iter (print_estrofa_result out_channel) lista_estrofas;
  output_string out_channel "\n\n";
  close_out out_channel;
  print_string "\nFicheiro analizado con éxito.\n"
;;

let () =
  match Array.to_list Sys.argv with
  | [_; input_file; output_file] ->
      validate_input_file input_file;
      analyze_file input_file output_file;
      exit 0
  | _ -> print_usage_and_exit ()

(* ************************************************************************ *)
