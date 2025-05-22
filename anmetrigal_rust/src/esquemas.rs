// Rust translation of src/lib/esquemas.ml

use std::collections::HashMap;
use once_cell::sync::Lazy; // Using once_cell for lazy static initialization

// Type alias for the value part of the HashMap for clarity.
// Represents (stanza_name, scheme_pattern, rhyme_type).
// - stanza_name: &'static str, e.g., "Pareado", "Soneto".
// - scheme_pattern: Vec<char>, e.g., vec!['A', 'B', 'B', 'A']. Represents the rhyme scheme.
// - rhyme_type: &'static str, e.g., "CO" (consonante), "AS" (asonante).
pub type SchemeInfo = (&'static str, Vec<char>, &'static str);

// Type alias for the HashMap itself.
// Maps number of verses (i32) to a list of possible scheme information.
pub type SchemesMap = HashMap<i32, Vec<SchemeInfo>>;

// Function to initialize the HashMap with poetic schemes.
// This function is called by the LAZY_STATIC initializer.
fn crear_tabla_esquemas() -> SchemesMap {
    let mut map: SchemesMap = HashMap::new();

    // Data from src/lib/esquemas.ml:
    // let _=Hashtbl.add tablaEsquemas 1 [("Verso libre",['a'],"CO");("Verso libre",['A'],"CO")];;
    map.entry(1).or_insert_with(Vec::new).push(("Verso libre", vec!['a'], "CO"));
    map.entry(1).or_insert_with(Vec::new).push(("Verso libre", vec!['A'], "CO"));

    // let _=Hashtbl.add tablaEsquemas 2 [("Pareado", ['a';'a'],"CO");("Pareado",['A';'A'],"CO")];;
    map.entry(2).or_insert_with(Vec::new).push(("Pareado", vec!['a', 'a'], "CO"));
    map.entry(2).or_insert_with(Vec::new).push(("Pareado", vec!['A', 'A'], "CO"));

    // let _=Hashtbl.add tablaEsquemas 3 [("Terceto",['A';'-';'A'],"CO");("Soleá",['a';'-';'a'],"AS")];;
    map.entry(3).or_insert_with(Vec::new).push(("Terceto", vec!['A', '-', 'A'], "CO"));
    map.entry(3).or_insert_with(Vec::new).push(("Soleá", vec!['a', '-', 'a'], "AS"));

    // let _=Hashtbl.add tablaEsquemas 4 [("Cuarteto",['A';'B';'B';'A'],"CO"); ... ];;
    map.entry(4).or_insert_with(Vec::new).push(("Cuarteto", vec!['A', 'B', 'B', 'A'], "CO"));
    map.entry(4).or_insert_with(Vec::new).push(("Redondilla", vec!['a', 'b', 'b', 'a'], "CO"));
    map.entry(4).or_insert_with(Vec::new).push(("Serventesio", vec!['A', 'B', 'A', 'B'], "CO"));
    map.entry(4).or_insert_with(Vec::new).push(("Cuarteta", vec!['a', 'b', 'a', 'b'], "CO"));
    map.entry(4).or_insert_with(Vec::new).push(("Copla", vec!['-', 'a', '-', 'a'], "AS"));
    map.entry(4).or_insert_with(Vec::new).push(("Cuaderna vía", vec!['A', 'A', 'A', 'A'], "CO"));

    // let _=Hashtbl.add tablaEsquemas 5 [("Quinteto",['A';'B';'A';'B';'A'],"CO"); ... ];;
    map.entry(5).or_insert_with(Vec::new).push(("Quinteto", vec!['A', 'B', 'A', 'B', 'A'], "CO"));
    map.entry(5).or_insert_with(Vec::new).push(("Quinteto", vec!['A', 'A', 'B', 'A', 'B'], "CO"));
    map.entry(5).or_insert_with(Vec::new).push(("Quinteto", vec!['A', 'B', 'A', 'A', 'B'], "CO"));
    map.entry(5).or_insert_with(Vec::new).push(("Quintilla", vec!['a', 'b', 'a', 'b', 'a'], "CO"));
    map.entry(5).or_insert_with(Vec::new).push(("Quintilla", vec!['a', 'a', 'b', 'a', 'b'], "CO"));
    map.entry(5).or_insert_with(Vec::new).push(("Quintilla", vec!['a', 'b', 'a', 'a', 'b'], "CO"));
    map.entry(5).or_insert_with(Vec::new).push(("Lira", vec!['a', 'B', 'a', 'b', 'B'], "CO"));

    // let _=Hashtbl.add tablaEsquemas 6 [("Copla manriqueña",['a';'b';'c';'a';'b';'c'],"CO")];;
    map.entry(6).or_insert_with(Vec::new).push(("Copla manriqueña", vec!['a', 'b', 'c', 'a', 'b', 'c'], "CO"));

    // let _=Hashtbl.add tablaEsquemas 8 [("Copla arte maior",['A';'B';'B';'A';'A';'C';'C';'A'],"CO"); ... ];;
    map.entry(8).or_insert_with(Vec::new).push(("Copla arte maior", vec!['A', 'B', 'B', 'A', 'A', 'C', 'C', 'A'], "CO"));
    map.entry(8).or_insert_with(Vec::new).push(("Octava real", vec!['A', 'B', 'A', 'B', 'A', 'B', 'C', 'C'], "CO"));
    map.entry(8).or_insert_with(Vec::new).push(("Octava italiana", vec!['-', 'A', 'A', 'B', '-', 'C', 'C', 'B'], "CO"));
    map.entry(8).or_insert_with(Vec::new).push(("Octavilla", vec!['-', 'a', 'a', 'b', '-', 'c', 'c', 'b'], "CO"));
    
    // let _=Hashtbl.add tablaEsquemas 10 [("Décima",['a';'b';'b';'a';'a';'c';'c';'d';'d';'c'],"CO")];;
    map.entry(10).or_insert_with(Vec::new).push(("Décima", vec!['a', 'b', 'b', 'a', 'a', 'c', 'c', 'd', 'd', 'c'], "CO"));

    // let _=Hashtbl.add tablaEsquemas 14 [ ("Soneto",['A';'B';'B';'A';'A';'B';'B';'A';'A';'B';'A';'A';'B';'A'],"CO"); ... ];;
    map.entry(14).or_insert_with(Vec::new).push(("Soneto", vec!['A', 'B', 'B', 'A', 'A', 'B', 'B', 'A', 'A', 'B', 'A', 'A', 'B', 'A'], "CO"));
    map.entry(14).or_insert_with(Vec::new).push(("Soneto", vec!['A', 'B', 'B', 'A', 'C', 'D', 'D', 'C', 'A', 'B', 'A', 'A', 'B', 'A'], "CO"));
    map.entry(14).or_insert_with(Vec::new).push(("Soneto", vec!['A', 'B', 'B', 'A', 'C', 'D', 'D', 'C', 'A', 'B', 'A', 'B', 'A', 'B'], "CO"));
    map.entry(14).or_insert_with(Vec::new).push(("Soneto", vec!['A', 'B', 'A', 'B', 'C', 'D', 'C', 'D', 'A', 'B', 'A', 'B', 'A', 'B'], "CO"));

    map
}

// Global static HashMap, lazily initialized using once_cell.
// This ensures that `crear_tabla_esquemas` is called only once,
// the first time `TABLA_ESQUEMAS` is accessed.
pub static TABLA_ESQUEMAS: Lazy<SchemesMap> = Lazy::new(crear_tabla_esquemas);

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_tabla_esquemas_inicializacion_y_contenido() {
        // Access the map to ensure it initializes
        let map = &*TABLA_ESQUEMAS;

        // Check if the map is empty (it shouldn't be)
        assert!(!map.is_empty(), "Map should be populated.");

        // Check for a specific key and the number of entries for that key
        assert!(map.contains_key(&4), "Map should contain key 4 for cuartetos etc.");
        assert_eq!(map.get(&4).unwrap().len(), 6, "Key 4 should have 6 scheme entries.");

        // Check a specific entry for key 4 (e.g., Cuarteto: ABBA, CO)
        let schemes_for_4 = map.get(&4).unwrap();
        let cuarteto_scheme = schemes_for_4.iter().find(|s| s.0 == "Cuarteto");
        assert!(cuarteto_scheme.is_some(), "Cuarteto scheme should exist for key 4.");
        assert_eq!(cuarteto_scheme.unwrap().1, vec!['A', 'B', 'B', 'A']);
        assert_eq!(cuarteto_scheme.unwrap().2, "CO");

        // Check a specific entry for key 3 (e.g., Soleá: a-a, AS)
        let schemes_for_3 = map.get(&3).unwrap();
        let solea_scheme = schemes_for_3.iter().find(|s| s.0 == "Soleá");
        assert!(solea_scheme.is_some(), "Soleá scheme should exist for key 3.");
        assert_eq!(solea_scheme.unwrap().1, vec!['a', '-', 'a']);
        assert_eq!(solea_scheme.unwrap().2, "AS");
        
        // Check number of keys
        // Keys are 1, 2, 3, 4, 5, 6, 8, 10, 14
        assert_eq!(map.keys().len(), 9, "There should be 9 distinct keys (number of verses).");

        // Check total number of scheme variations
        let total_schemes: usize = map.values().map(|v| v.len()).sum();
        assert_eq!(total_schemes, 27, "Total number of scheme variations should be 27.");
    }
}
