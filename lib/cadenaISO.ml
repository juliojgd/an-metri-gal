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

(* Clase cadenaISO: *)
(*
   *
   * Implementada para tratar de forma uniforme los strings con caracteres
   * acentuados y otros símbolos.
   *
   * Métodos públicos relevantes:
   *
   *   Constructor cadenaISO: string -> cadenaISO.
   *                         Crea una nueva instancia de cadenaISO a partir de
   *                         un string.
   *
   *  get: string.
   *       Devuelve un string con el siguiente caracter (sea acentuado (2bytes)
   *       o no)
   *
   *  get2: string.
   *       Devuelve un string con los 2 siguientes caracteres.
   *
   *  s: string.
   *      Devuelve un string con el siguiente caracter e incrementa la
   *      posicion actual al sig. caracter.
   *
   *  sub: int->int->string.
   *       Devuelve un substring de la instancia.
   *
*)

(* ************************************************************************ *)

class cadenaISO cadena=
  object (self)
    val mutable _cadena= cadena

    val mutable _donde=0

    method donde= _donde

    method getCadena = _cadena

    method longitud = String.length _cadena

    method get =
      let t=String.sub _cadena _donde 1
      in
      if t="\129"
      then (String.sub _cadena _donde 2)
      else t

    method get2 =
      let (car,inc)=
	let t=String.sub _cadena _donde 1
	in
	if t="\129"
	then ( (String.sub _cadena _donde 2), 2 )
	else ( t, 1 )
      in
      let car2=
	let t=String.sub _cadena (_donde+inc) 1
	in
	if t="\129"
	then  (String.sub _cadena (_donde+inc) 2)
	else  t
      in
      car^car2

    method avanza d=
      if (_donde+d)<self#longitud then _donde <- _donde+d else raise (Invalid_argument "Clase cadenaISO")
    method s =
      let (car,inc)=
	let t=String.sub _cadena _donde 1
	in
	if t="\129"
	then ( (String.sub _cadena _donde 2), 2 )
	else ( t, 1 )
      in
      _donde <- _donde + inc;
      car

    method sinc=
      let car=
	let t=String.sub _cadena _donde 1
	in
	if t="\129"
	then  (String.sub _cadena _donde 2)
	else  t
      in
      car

    method sub i f=String.sub _cadena i f

end;;
