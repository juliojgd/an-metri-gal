open Alcotest

let test_cadenaISO_get_and_s () =
  let c = new Lib.CadenaISO.cadenaISO "abc" in
  check string "get first" "a" c#get;
  check string "s first" "a" c#s;
  check string "s second" "b" c#s;
  check int "position" 2 c#donde

let test_cadenaISO_get2 () =
  let c = new Lib.CadenaISO.cadenaISO "casa" in
  check string "next two chars" "ca" c#get2

let test_quita_vacio () =
  check (list string) "remove empties" ["a"; "b"] (Lib.Utiles.quita_vacio [""; "a"; ""; "b"])

let test_separa_estrofas () =
  let input = ["verso 1"; "verso 2"; "@"; "verso 3"] in
  check (list (list string)) "split by @" [["verso 1"; "verso 2"]; ["verso 3"]] (Lib.Utiles.separa_estrofas input)

let test_quita_acent () =
  check string "remove # markers" "cantare" (Lib.Utiles.quita_acent "can#ta#re")

let test_analiza () =
  check (list string) "syllable split" ["ca"; "sa"] (Lib.Utiles.analiza "casa")

let test_tras_acento () =
  check string "substring after #" "te" (Lib.Utiles.tras_acento "can#te")

let test_solo_vocales () =
  check string "keep vowels" "aioaa" (Lib.Utiles.solo_vocales "cancionada")

let test_normaliza_vocales_asonante () =
  check string "open e and o are distinct" "EOaeiu" (Lib.Utiles.normaliza_vocales_asonante "\129\233\129\243\129\225e\129\237\129\250")

let test_riman_asonante_true () =
  check bool "same assonance" true (Lib.Utiles.riman_en_asonante ["casa"; "pata"])

let test_riman_asonante_false () =
  check bool "different assonance" false (Lib.Utiles.riman_en_asonante ["casa"; "cielo"])

let test_riman_asonante_open_closed_distinction () =
  check bool
    "open and closed galician vowels do not match"
    false
    (Lib.Utiles.riman_en_asonante ["f\129\233r"; "fer"])

let test_riman_consonante_true () =
  check bool "same ending" true (Lib.Utiles.riman_en_consonante ["canto"; "canto"])

let test_riman_consonante_false () =
  check bool "different ending" false (Lib.Utiles.riman_en_consonante ["canto"; "canta"])

let test_trata_verso () =
  let sil, fin = Lib.Utiles.trata_verso "c#asa" in
  check int "syllables" 2 sil;
  check string "ending" "asa" fin

let test_trata_estrofa_and_num_versos () =
  let estrofa = ["c#asa"; "p#ata"] in
  let tratada = Lib.Utiles.trata_estrofa estrofa in
  check int "verse count" 2 (Lib.Utiles.num_versos estrofa);
  check int "processed entries" 2 (List.length tratada)

let test_encaja_arte_menor () =
  let est = [(8, "asa"); (8, "asa")] in
  let esq = ("Pareado", ['a'; 'a'], "CO") in
  check bool "lowercase matches arte menor" true (Lib.Utiles.encaja est esq)

let test_encaja_arte_mayor () =
  let est = [(11, "ado"); (11, "ido")] in
  let esq = ("Pareado", ['A'; 'A'], "CO") in
  check bool "uppercase matches arte mayor" true (Lib.Utiles.encaja est esq)

let test_identifica_estrofa () =
  let est = [(8, "asa"); (8, "asa")] in
  let nombre, _, _ = Lib.Utiles.identifica_estrofa est in
  check string "detected schema" "Pareado" nombre

let () =
  run "anmetrigal" [
    ("cadenaISO", [
      test_case "get and s" `Quick test_cadenaISO_get_and_s;
      test_case "get2" `Quick test_cadenaISO_get2;
    ]);
    ("utiles", [
      test_case "quita_vacio" `Quick test_quita_vacio;
      test_case "separa_estrofas" `Quick test_separa_estrofas;
      test_case "quita_acent" `Quick test_quita_acent;
      test_case "analiza" `Quick test_analiza;
      test_case "tras_acento" `Quick test_tras_acento;
      test_case "solo_vocales" `Quick test_solo_vocales;
      test_case "normaliza_vocales_asonante" `Quick test_normaliza_vocales_asonante;
      test_case "riman asonante true" `Quick test_riman_asonante_true;
      test_case "riman asonante false" `Quick test_riman_asonante_false;
      test_case "riman asonante open/closed" `Quick test_riman_asonante_open_closed_distinction;
      test_case "riman consonante true" `Quick test_riman_consonante_true;
      test_case "riman consonante false" `Quick test_riman_consonante_false;
      test_case "trata_verso" `Quick test_trata_verso;
      test_case "trata_estrofa and num_versos" `Quick test_trata_estrofa_and_num_versos;
      test_case "encaja arte menor" `Quick test_encaja_arte_menor;
      test_case "encaja arte mayor" `Quick test_encaja_arte_mayor;
      test_case "identifica_estrofa" `Quick test_identifica_estrofa;
    ]);
  ]
