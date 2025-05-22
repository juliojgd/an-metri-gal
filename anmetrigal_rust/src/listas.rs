// Rust translation of src/lib/listas.ml
// IMPORTANT ASSUMPTIONS:
// 1. OCaml byte sequences like "\129\225" are intended to represent standard UTF-8 characters (e.g., "á").
//    This means that the CadenaISO struct, when processing these byte sequences, should ideally produce
//    these UTF-8 characters. The lists below are defined with these target UTF-8 characters.
// 2. The '�' (U+FFFD) characters found in the OCaml source for 'consonantes' and 'separadores'
//    are interpreted as specific characters (ñ, ¿, ¡).

// Consonantal groups
pub static GRUPOS_CONSONANTICOS: &'static [&'static str] = &[
    "bl", "br", "cc", "ch", "cl", "cr", "dr", "fl", "fr", "gr", "gl", "kl", "kr", "ll", "pl", "pr", "rr", "tl", "tr", "vl", "vr", "wl", "wr", "zl", "zr",
];

// Diphthongs
// Assuming "\129\243" is 'ó' and "\129\225" is 'á'
pub static DIPTONGOS: &'static [&'static str] = &[
    "ai", "au", "ei", "eu", "ia", "ie", "iu", "io", "oi", "ou", "ua", "ue", "ui", "uo",
    "ee", // Note: "ee" is often a hiatus, but listed as diphthong in source.
    "ii", // Note: "ii" is often a hiatus, but listed as diphthong in source.
    "ió", // OCaml: "i\129\243"
    "iá", // OCaml: "i\129\225"
];

// Hiatuses (sequences that look like diphthongs but form hiatus)
// Assuming: \129\225 -> á, \129\233 -> é, \129\237 -> í, \129\243 -> ó, \129\250 -> ú
pub static HIATOS: &'static [&'static str] = &[
    "aa", "ae", "ao", "áa", "áe", "áo", // OCaml: "\129\225a";"\129\225e";"\129\225o";
    "aá", "aé", "aí", "aó", "aú", // OCaml: "a\129\225";"a\129\233";"a\129\237";"a\129\243";"a\129\250";
    "ea", "ee", "eo", "éa", "ée", "éo", // OCaml: "\129\233a";"\129\233e";"\129\233o";
    "eá", "eé", "eí", "eó", "eú", // OCaml: "e\129\225";"e\129\233";"e\129\237";"e\129\243";"e\129\250";
    "ía", "íe", "ío", "íu",             // OCaml: "\129\237a";"\129\237e";"\129\237o";"\129\237u";
    "oa", "oe", "oo",
    "óa", "óe", "óo",                   // OCaml: "\129\243a"; "\129\243e"; "\129\243o";
    "oá", "oé", "oí", "oó", "oú", // OCaml: "o\129\225";"o\129\233";"o\129\237";"o\129\243";"o\129\250";
    "úa", "úo", "úe",                   // OCaml: "\129\250a";"\129\250o";"\129\250e"
];

// Consonants
// Assuming '�' in the OCaml source is 'ñ'
pub static CONSONANTES: &'static [&'static str] = &[
    "b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n",
    "ñ", // OCaml: "�" - Assuming this is ñ (U+00F1)
    "p", "q", "r", "s", "t", "v", "w", "x", "z",
];

// Separators
// Assuming '�' characters in OCaml source are '¿' and '¡'
pub static SEPARADORES: &'static [&'static str] = &[
    ",", ".", 
    "¿", // OCaml: "�" - Assuming ¿ (U+00BF)
    "?", 
    "¡", // OCaml: "�" - Assuming ¡ (U+00A1)
    "!", ";", ":", "-", "_", "(", ")",
];

// Vowels without tilde (accent)
pub static VOCALES_SIN: &'static [&'static str] = &["a", "e", "i", "o", "u"];

// Vowels with tilde (accent)
// Assuming "\129\225" -> "á", etc.
pub static VOCALES_TILDE: &'static [&'static str] = &["á", "é", "í", "ó", "ú"];

// All vowels (combination of sin and con tilde)
pub static VOCALES: &'static [&'static str] = &[
    "a", "e", "i", "o", "u", "á", "é", "í", "ó", "ú",
];

// For reference, the OCaml byte sequences and their assumed UTF-8 interpretation:
// "\129\225" -> "á" (U+00E1, UTF-8: C3 A1)
// "\129\233" -> "é" (U+00E9, UTF-8: C3 A9)
// "\129\237" -> "í" (U+00ED, UTF-8: C3 AD)
// "\129\243" -> "ó" (U+00F3, UTF-8: C3 B3)
// "\129\250" -> "ú" (U+00FA, UTF-8: C3 BA)
// The byte 129 is 0x81. The OCaml sequences are e.g. [0x81, 0xE1] for "á".
// This interpretation implies that CadenaISO should convert these byte pairs into the corresponding UTF-8 strings.
// If CadenaISO instead produces lossy UTF-8 (like "\uFFFD\uFFFD") from these byte pairs,
// then these lists would need to contain those lossy strings to match, which would make
// all accented vowels identical and is unlikely to be the correct behavior for the application.
// The '�' character (U+FFFD) appearing in OCaml's `consonantes` and `separadores` lists
// has been interpreted as 'ñ', '¿', and '¡' respectively. If this is incorrect,
// the actual U+FFFD character ("\u{FFFD}") should be used instead.
