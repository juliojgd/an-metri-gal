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
   * Listas conteniendo vocales (con y sin tilde), consonantes, diptongos,
   * hiatos, grupos conson�nticos y separadores.
   *
*)

(* ********************************************************************** *)
let grupos_consonanticos=["bl";"br";"cc";"ch";"cl";"cr";"dr";"fl";"fr";"gr";"gl";"kl";"kr";"ll";"pl";"pr";"rr";"tl";"tr";"vl";"vr";"wl";"wr";"zl";"zr"];;

let diptongos=["ai";"au";"ei";"eu";"ia";"ie";"iu";"io";"oi";"ou";"ua";"ue";"ui";"uo";"ee";"ii";"i\129\243";"i\129\225"];;

let hiatos=["aa";"ae";"ao";"\129\225a";"\129\225e";"\129\225o";
	     "a\129\225";"a\129\233";"a\129\237";"a\129\243";"a\129\250";
	     "ea";"ee";"eo";"\129\233a";"\129\233e";"\129\233o";
	     "e\129\225";"e\129\233";"e\129\237";"e\129\243";"e\129\250";
	     "\129\237a";"\129\237e";"\129\237o";"\129\237u";
	     "oa";"oe";"oo";
	     "\129\243a"; "\129\243e"; "\129\243o";
	     "o\129\225";"o\129\233";"o\129\237";"o\129\243";"o\129\250";
	     "\129\250a";"\129\250o";"\129\250e"];;

let consonantes=["b";"c";"d";"f";"g";"h";"j";"k";"l";"m";"n";"�";"p";"q";"r";"s";"t";"v";"w";"x";"z"];;

let separadores=[",";".";"�";"?";"�";"!";";";":";"-";"_";"(";")"];;
let vocales_sin=["a";"e";"i";"o";"u"];;
let vocales_tilde=["\129\225";"\129\233";"\129\237";"\129\243";"\129\250"];;
let vocales=vocales_sin@vocales_tilde;;
