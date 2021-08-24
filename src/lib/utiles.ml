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


open CadenaISO;;
open Listas;;
open Esquemas;;
(* ************************************************************************ *)

let vuelta st=
(*
   * Funcion que da la vuelta a un String.
   *
   *
*)
  let ob=new cadenaISO st
  in
  let rec aux pos=
    let t=
      try
	ob#s
      with
	Invalid_argument (_)-> ""
    in
    if t="" then "" else (aux pos)^t
  in
  aux 0;;



let es_grupo_valido cade =
(*
   * Devuelve true si el grupo consonantico que empieza donde se le
   * pasa es un grupo consonantico valido.
   *
*)
    List.mem (vuelta cade) grupos_consonanticos;;



let es_diptongo cade =
(*
   * Funcion que devuelve true si los 2 caracteres desde "donde" en el String
   * "cade" son un diptongo, false en otro caso.
   *
*)
    List.mem (vuelta cade) diptongos;;





let es_hiato cade =
(*
   * Funcion que devuelve true si los 2 caracteres desde "donde" en el String
   * "cade" son un hiato, false en otro caso.
   *
*)
    List.mem (vuelta cade) hiatos;;




let es_vocal cade =
(*
   * Funcion que devuelve true si el caracter desde "donde" en el String
   * "cade" es una vocal, false en otro caso.
   *
*)
    List.mem cade vocales;;




let es_consonante cade =
(*
   * Funcion que devuelve true si el caracter desde "donde" en el String
   * "cade" es una consonante, false en otro caso.
   *
*)
    List.mem cade consonantes;;


(* ******************************************************************* *)



(* ******************************************************************  *)

(*
   * Acondicionamiento de las listas de versos.
   *
   *
*)
let rec quita_vacio l=
  match l with
    []    -> []
  | a::l1 -> if a="" then quita_vacio l1 else a::(quita_vacio l1);;

let separa_estrofas l=
  let t=quita_vacio l
  in
  let rec aux lista=
    match lista with
      []    -> [[]]
    | a::l1 ->
	let t2=aux l1
	in
	if (String.contains a '@')
	then []::t2
	else (a::(List.hd (t2)))::(List.tl t2)
  in
  aux t;;


let es_separador st=(List.mem st separadores);;


let pon_separadores cade =
  let rec aux i=
    if (i<String.length cade)
    then
      (
       if (es_separador (String.sub cade i 1))
       then Bytes.set cade i '|'
       else ();
       aux (i+1)
      )
    else ()
  in
  aux 0
;;


(* *************************************************************** *)

(*
   * Separaci�n de s�labas
   *
   *
*)

let analiza cadena=
  let _cadena=new cadenaISO (vuelta (String.lowercase cadena))
  in
  let _dondeparo=ref 0
  in
  let _donde=ref 0
  in
  let r=ref false
  in
  let _silabas=ref []
  in
  while (not !r) do
    try
      while (not (es_vocal _cadena#get)) do
	       ignore _cadena#s
      done;
      if  (es_hiato _cadena#get2 )
      then
	(ignore _cadena#s;())
      else
	(
	 if (es_diptongo _cadena#get2 )
	 then (ignore _cadena#s; ignore _cadena#s)
	 else ignore _cadena#s;
	 if (es_grupo_valido _cadena#get2 )
	 then (ignore _cadena#s; ignore _cadena#s;())
	 else
	   (ignore _cadena#s;())
	);
      _silabas := (!_silabas)@[ vuelta (_cadena#sub !_dondeparo ((_cadena#donde)-(!_dondeparo)))];
      _dondeparo := _cadena#donde;
    with
      Invalid_argument (_) ->
	(
	 r := true;
	 _silabas := (!_silabas)@[ vuelta (
				   try
				     _cadena#sub !_dondeparo ((_cadena#donde+1)-(!_dondeparo))
				   with
				     Invalid_argument (_) ->
				       _cadena#sub !_dondeparo ((_cadena#donde)-(!_dondeparo))
)]
	)
  done;
  List.rev !_silabas;;


(* ********************************************************************** *)

let quita_acent cade=
  (*
     * Funci�n que elimina la marca de acentuaci�n de �ltima s�laba acentuada
     * (obligatoria antes de la �ltima vocal con acento en el verso)
     * Marcada con un "#". Lo quita para facilitar el contaje de s�labas.
  *)
  let rec qaux d=
    let car=
      try
	(String.sub cade d 1)
      with Invalid_argument (_) -> ""
    in
    if car=""
    then car
    else
      if car="#" then qaux (d+1) else car^qaux (d+1)
  in
  qaux 0;;

(* ********************************************************************** *)
let tras_acento verso=
(*
   * Funci�n que devuelve un string con lo que hay en un verso despues de
   * la se�al de acento.
   *
*)
  let l=String.length verso
  in
  let rec aux a d=
    if (d<l) then
      let t=String.sub verso d 1
      in
      if a then (t)^(aux a (d+1))
      else
	if (t="#") then aux true (d+1)
	else aux a (d+1)
    else ""
  in
  aux false 0;;


(* ********************************************************************** *)
let cuenta_silabas ver=
(*
   *
   * Cuenta las silabas de un verso, en el que analiza separar� las silabas.
   * Tiene en cuenta sinalefas.
*)
  let verso=analiza (quita_acent ver)
  in
  let numero_bruto=List.length verso
  in
  let primera_letra st=
    let ob=new cadenaISO st
    in
    ob#s
  in
  let ultima_letra st=
    primera_letra (vuelta st)
  in
  let quita_espacios c=
    let ob2=new cadenaISO c
    in
    let rec aux a=
      let t=
	try
	  ob2#s
	    with
	  Invalid_argument (_) -> ""
      in
      if t="" then ""
      else if t=" " then (aux a) else (t^(aux a))
    in
    aux 0
  in
  let numero_sinalefas=
    let rec aux v=
      match v with
	[]           -> 0
      | _::[]        -> 0
      | a::b::resto  ->
	  let uni=((ultima_letra (quita_espacios a))^(primera_letra (quita_espacios b)))
	  in
	  let tiene_espacios=( ((ultima_letra a)=" ") || ((primera_letra b)=" "))
	  in
	  if ( (es_diptongo uni) || (es_hiato uni) ) && tiene_espacios
	  then
	    (
	     1+(aux (b::resto))
	    )
	else
	    (
	     aux (b::resto)
	    )
    in
    aux verso
  in
  let prev1= numero_bruto-numero_sinalefas
      (* Ahora debo tener en cuenta si la palabra es aguda, llana o esr�jula *)
  in
  let cuantas_despues=List.length (analiza (tras_acento ver))
  in
  if (cuantas_despues<2) then  (prev1 + 1)
  else
    if (cuantas_despues>2) then (prev1 - 1)
    else prev1;;





(* ****************************************************************** *)

(*
   *  Contado de versos, rima, etc.
   *
   *
*)

let sin_tildes st=
  (*
     * Sustituye todas las vocales con tilde de un string por vocales
     * sin tilde.
     *
  *)
  let lista_equi=[("�","a");("�","e");("�","i");("�","o");("�","u")]
  in
  let ob=new cadenaISO st
  in
  let rec qaux d=
    let car=
      try
	ob#s
      with
	Invalid_argument (_)->""
    in
    if car=""
    then car
    else
      let t2=
	if (List.mem_assoc car lista_equi)
	then  (List.assoc car lista_equi)
	else car
      in
      (t2)^qaux d
  in
  qaux 0;;

(* ********************************************************************** *)
let solo_vocales st=
  (*
     *  Elimina de un string todo lo que no sean vocales (las deja en orden)
     *
     *
  *)
  let ob=new cadenaISO st
  in
  let rec qaux d=
    let car=
      try
	ob#s
      with Invalid_argument (_) -> ""
    in
    if car=""
    then car
    else
      let t2=if (es_vocal car ) then car else ""
      in
      (t2)^qaux (d)
  in
  qaux 0;;



(* ********************************************************************** *)
let riman_en_asonante lista=
  (*
     * Funcion que devuelve true  si la lista de terminaciones de verso
     * riman en asonante (s�lo vocales despu�s de s�laba t�nica).
     *
  *)
  let temp=List.map sin_tildes lista
   in
  let sin_consonantes=List.map solo_vocales temp
  in
  let rec aux _ k=
    match k with
      []          -> true
    | a::b::resto -> (a=b) && (aux b resto)
    | _::[]       ->true
  in
  aux "" sin_consonantes;;

(* ********************************************************************** *)
let riman_en_consonante lista=
  (*
     * Funcion que devuelve true  si la lista de terminaciones de verso
     * riman en consonante (todas letras despues de s�laba t�nica).
     *
  *)
  let temp=List.map sin_tildes lista
   in
  let rec aux _ k=
    match k with
      []          -> true
    | a::b::resto -> (a=b) && (aux b resto)
    | _::[]       ->true
  in
  aux "" temp;;


(* ********************************************************************** *)
let trata_verso ver=
  (*
     *  Devuelve un par (num_silabas, letras_despues_de_vocal_tonica) para
     *  un verso.
     *
  *)
  (cuenta_silabas  ver,sin_tildes (tras_acento ver));;


(* ********************************************************************** *)
let trata_estrofa est=
  (*
     * Funcion que devuelve una lista de pares
     * (num_silabas, letras_despues_de_vocal_tonica) para cada verso de una
     * estrofa
  *)
  List.map trata_verso est;;


(* ********************************************************************** *)
let num_versos estrofa=
(*
   * Funcion que cuenta el numero de versos de una estrofa (Lista de Strings)
   *
   *
*)
  List.length estrofa;;



(* ********************************************************************** *)
let encaja est esq=
  (*
     *  Esta funci�n filtra y devuelve true para los esquemas que
     *  coinciden en el arte (mayor o menor) de sus corresp. versos.
     *
  *)
  let  verso_arte_mayor l j=
    let (i,_)=(List.nth l j)
    in (i>8)
  in
  let esq_arte_mayor (_,lista,_) i=
    let a=(List.nth lista i)
    in
    (a=(Char.uppercase a))
  in
  let rec aux i=
    let le=List.length est
    in
    if i<le
    then ((verso_arte_mayor est i)=(esq_arte_mayor esq i))&&(aux (i+1))
    else true
  in
  aux 0;;


(* ********************************************************************** *)
let rec rima_con_alguno term est arra donde letra=
  match est with
    []          -> false
  | (sil,t1)::l1      ->
      if (riman_en_asonante [term;t1])
      then
	(
	 let base=if sil>8 then (Char.code 'A') else (Char.code 'a')
	 in
	 arra.(donde) <- Char.chr (base+letra);
	 (rima_con_alguno term l1 arra (donde+1) letra) || true
	)
      else
	rima_con_alguno term l1 arra (donde+1) letra
	  ;;


(* ********************************************************************** *)
let crea_su_esquema est=
  (*
     *  Funci�n que devuelve una lista de caracteres con el esquema de rima
     *  de la estrofa que se le pasa (lista de pares (num_s�labas,terminaci�n))
     *
     *
*)
  let ara=Array.make (List.length est) '#'
  in
  let rec crea l ar letra donde =
    match  l with
      []               -> Array.to_list ar
    | (sil,term)::est2   ->
	(
	 if (ar.(donde)='#')
	 then
	   (
	    let base=if sil>8 then (Char.code 'A') else (Char.code 'a')
	    in
	    ar.(donde) <- Char.chr (base+letra);
	    if (rima_con_alguno term est2 ar (donde+1) letra)
	    then
	      crea est2 ar (letra+1) (donde+1)
	    else
	      (
		  ar.(donde) <- '-';
	       crea est2 ar letra (donde+1)
	      )
	   )
	 else   crea est2 ar letra (donde+1)
	)
  in
  crea est ara 0 0;;

(* ********************************************************************** *)
let identifica_estrofa est=
  let nv=List.length est
  in
  let esq=
    try
      Hashtbl.find tablaEsquemas nv
    with
      Not_found -> []
  in
  let mi_estructura=crea_su_esquema est
  in
  let rec recorre p=
    match p with
      []             -> ("Estrofa Desco�ecida ",mi_estructura,"CO")
    |	(nm,l1,ri)::l  ->
	if (List.for_all2 (function a->function b->(a= b)) mi_estructura l1)
	then
	  (nm,l1,ri)
	else
	  recorre l
  in
  recorre esq ;;


(* ********************************************************************** *)
(* ********************************************************************** *)
