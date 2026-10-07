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

let test_sin_tildes () =
  check string "strip accents (internal 2-byte form)" "aeiou"
    (Lib.Utiles.sin_tildes "\129\225\129\233\129\237\129\243\129\250");
  check string "strip accents (bare latin-1 form)" "aeiou"
    (Lib.Utiles.sin_tildes "\225\233\237\243\250");
  check string "strip accents in a word" "camion" (Lib.Utiles.sin_tildes "cami\243n")

let test_es_consonante_nie () =
  check bool "internal encoded ñ is consonant" true (Lib.Utiles.es_consonante "\129\241");
  check bool "latin-1 ñ is consonant" true (Lib.Utiles.es_consonante "\241")

let test_analiza_nie () =
  check (list string) "syllables with ñ" ["ca"; "mi"; "\241o"] (Lib.Utiles.analiza "cami\241o")

let test_pon_separadores () =
  check string "¿ treated as separator" "canta| " (Lib.Utiles.pon_separadores "canta\191 ");
  check string "¡ treated as separator" "|canta" (Lib.Utiles.pon_separadores "\161canta")

let test_trata_verso_conserves_tildes () =
  check string "rhyme tail keeps accent marks" "i\243n" (snd (Lib.Utiles.trata_verso "cam#i\243n"))

let test_identifica_estrofa_desco () =
  let nombre, _, _ = Lib.Utiles.identifica_estrofa [] in
  check string "unknown stanza message is human readable" "Estrofa Descoñecida " nombre

let test_riman_asonante_true () =
  check bool "same assonance" true (Lib.Utiles.riman_en_asonante ["casa"; "pata"])

let test_riman_asonante_false () =
  check bool "different assonance" false (Lib.Utiles.riman_en_asonante ["casa"; "cielo"])

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
      test_case "riman asonante true" `Quick test_riman_asonante_true;
      test_case "riman asonante false" `Quick test_riman_asonante_false;
      test_case "riman consonante true" `Quick test_riman_consonante_true;
      test_case "riman consonante false" `Quick test_riman_consonante_false;
      test_case "trata_verso" `Quick test_trata_verso;
      test_case "trata_estrofa and num_versos" `Quick test_trata_estrofa_and_num_versos;
      test_case "sin_tildes" `Quick test_sin_tildes;
      test_case "ñ es consonante" `Quick test_es_consonante_nie;
      test_case "analiza ñ" `Quick test_analiza_nie;
      test_case "pon_separadores ¿ ¡" `Quick test_pon_separadores;
      test_case "trata_verso conserva tildes" `Quick test_trata_verso_conserves_tildes;
      test_case "mensagem descoñecida" `Quick test_identifica_estrofa_desco;
      test_case "encaja arte menor" `Quick test_encaja_arte_menor;
      test_case "encaja arte mayor" `Quick test_encaja_arte_mayor;
      test_case "identifica_estrofa" `Quick test_identifica_estrofa;
    ]);
  ]
