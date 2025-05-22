// Rust translation of src/lib/cadenaISO.ml

use std::collections::HashMap;
use once_cell::sync::Lazy;

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum CadenaIsoError {
    AvanzaOutOfBounds,
}

// Static map for special byte sequences to UTF-8 strings
static SPECIAL_CHAR_MAP: Lazy<HashMap<Vec<u8>, &'static str>> = Lazy::new(|| {
    let mut m = HashMap::new();
    // Mappings based on listas.ml interpretation
    m.insert(vec![129, 225], "á");
    m.insert(vec![129, 233], "é");
    m.insert(vec![129, 237], "í");
    m.insert(vec![129, 243], "ó");
    m.insert(vec![129, 250], "ú");
    // Add other known mappings if any. For example, from the prompt's description for listas.ml:
    // It seems the OCaml file itself uses these \129\... sequences directly.
    // The prompt's "9X" characters like \195\161 for "á" are standard UTF-8, which will be handled by the UTF-8 decoding fallback.
    m
});

const REPLACEMENT_CHAR: &str = "\u{FFFD}";

#[derive(Debug, Clone)]
pub struct CadenaISO {
    cadena_bytes: Vec<u8>, // Store as bytes
    donde: usize,          // Current position in bytes
}

impl CadenaISO {
    pub fn new(s: String) -> Self {
        CadenaISO {
            cadena_bytes: s.into_bytes(),
            donde: 0,
        }
    }

    pub fn from_str(s: &str) -> Self {
        CadenaISO {
            cadena_bytes: s.as_bytes().to_vec(),
            donde: 0,
        }
    }
    
    // Helper to create from bytes, useful for tests
    #[cfg(test)]
    fn from_bytes(bytes: &[u8]) -> Self {
        CadenaISO {
            cadena_bytes: bytes.to_vec(),
            donde: 0,
        }
    }

    pub fn get_bytes(&self) -> &[u8] {
        &self.cadena_bytes
    }

    pub fn longitud(&self) -> usize {
        self.cadena_bytes.len()
    }

    /// Decodes a character starting at a given byte position.
    /// Returns the character as a String and the number of bytes consumed.
    fn decode_char_at(&self, pos: usize) -> Option<(String, usize)> {
        if pos >= self.longitud() {
            return None;
        }

        // 1. Check for special 2-byte sequences starting with 129
        if self.cadena_bytes[pos] == 129 {
            if pos + 1 < self.longitud() {
                let seq = &self.cadena_bytes[pos..pos + 2];
                if let Some(mapped_char_str) = SPECIAL_CHAR_MAP.get(seq) {
                    return Some((mapped_char_str.to_string(), 2));
                }
            }
            // If 129 is at the end or not part of a known sequence, treat as replacement
            return Some((REPLACEMENT_CHAR.to_string(), 1));
        }

        // 2. Attempt to decode standard UTF-8 character
        // Check 1-byte UTF-8 (ASCII)
        if self.cadena_bytes[pos] < 128 { // 0xxxxxxx
            return Some((String::from_utf8_lossy(&self.cadena_bytes[pos..pos+1]).to_string(), 1));
        }

        // Check multi-byte UTF-8
        // Determine expected length
        let byte1 = self.cadena_bytes[pos];
        let expected_len = if (byte1 & 0xE0) == 0xC0 { 2 } // 110xxxxx
                           else if (byte1 & 0xF0) == 0xE0 { 3 } // 1110xxxx
                           else if (byte1 & 0xF8) == 0xF0 { 4 } // 11110xxx
                           else { 0 }; // Invalid start byte

        if expected_len == 0 { // Invalid UTF-8 start byte
            return Some((REPLACEMENT_CHAR.to_string(), 1));
        }

        if pos + expected_len > self.longitud() { // Not enough bytes for expected sequence
            return Some((REPLACEMENT_CHAR.to_string(), 1)); // Consume only the invalid start byte
        }

        let potential_utf8_seq = &self.cadena_bytes[pos .. pos + expected_len];
        match std::str::from_utf8(potential_utf8_seq) {
            Ok(s) => Some((s.to_string(), expected_len)),
            Err(_) => {
                // Sequence is not valid UTF-8, return replacement for the first byte
                Some((REPLACEMENT_CHAR.to_string(), 1))
            }
        }
    }

    pub fn sinc(&self) -> Option<String> {
        self.decode_char_at(self.donde).map(|(s, _)| s)
    }

    pub fn get(&self) -> Option<String> {
        self.sinc()
    }

    pub fn s(&mut self) -> Option<String> {
        match self.decode_char_at(self.donde) {
            Some((s, bytes_consumed)) => {
                self.donde += bytes_consumed;
                Some(s)
            }
            None => None,
        }
    }
    
    pub fn get2(&self) -> Option<String> {
        let (s1, len1) = self.decode_char_at(self.donde)?;
        let (s2, _len2) = self.decode_char_at(self.donde + len1)?;
        Some(s1 + &s2)
    }

    pub fn avanza(&mut self, d: usize) -> Result<(), CadenaIsoError> {
        // Note: `d` is number of "characters" as defined by OCaml, not bytes.
        // This requires iterating `d` times, consuming chars one by one.
        let mut bytes_to_advance = 0;
        let mut current_pos = self.donde;
        for _ in 0..d {
            if let Some((_, consumed)) = self.decode_char_at(current_pos) {
                bytes_to_advance += consumed;
                current_pos += consumed;
                 if current_pos > self.longitud() { // Should not happen if decode_char_at is correct
                    return Err(CadenaIsoError::AvanzaOutOfBounds);
                }
            } else { // Not enough characters to advance `d` times
                return Err(CadenaIsoError::AvanzaOutOfBounds);
            }
        }
        
        // Original OCaml logic for avanza: `if (_donde+d)<self#longitud then _donde <- _donde+d else raise`
        // This was byte-based. The re-interpretation for `d` as char count makes it trickier.
        // For now, let's assume `d` is byte count to match existing test logic and OCaml's directness.
        // If `d` is truly char count, the above loop is better.
        // Reverting to simpler byte-based advance for now, as per existing tests and OCaml's directness.
        // The problem description for `avanza d` from OCaml did not specify `d` as char count.
        if self.donde + d <= self.longitud() { // Allow advancing to end.
            self.donde += d;
            Ok(())
        } else {
            Err(CadenaIsoError::AvanzaOutOfBounds)
        }
    }

    pub fn sub(&self, start_byte_index: usize, length_in_bytes: usize) -> Option<String> {
        if start_byte_index + length_in_bytes > self.longitud() {
            return None;
        }

        let mut result = String::new();
        let mut current_pos = start_byte_index;
        let end_pos = start_byte_index + length_in_bytes;

        while current_pos < end_pos {
            if let Some((s, bytes_consumed)) = self.decode_char_at(current_pos) {
                // Ensure we don't read past the requested length_in_bytes
                if current_pos + bytes_consumed > end_pos {
                    // This character extends beyond the subsegment.
                    // Append replacement chars for remaining bytes in the subsegment.
                    for _ in current_pos..end_pos {
                        result.push_str(REPLACEMENT_CHAR);
                    }
                    break; 
                }
                result.push_str(&s);
                current_pos += bytes_consumed;
            } else {
                // Should not happen if current_pos < end_pos and end_pos <= self.longitud()
                // But if it does, indicates an issue, append replacement and break
                result.push_str(REPLACEMENT_CHAR);
                current_pos += 1; 
            }
        }
        Some(result)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_new_longitud() {
        let s = "hello";
        let cis = CadenaISO::from_str(s);
        assert_eq!(cis.longitud(), 5);
        assert_eq!(cis.donde, 0);
    }

    #[test]
    fn test_avanza() { // Assuming avanza takes byte count for now
        let mut cis = CadenaISO::from_str("hello world"); // len 11
        assert_eq!(cis.avanza(6), Ok(())); 
        assert_eq!(cis.donde, 6);
        assert_eq!(cis.avanza(5), Ok(())); 
        assert_eq!(cis.donde, 11);
        assert_eq!(cis.avanza(1), Err(CadenaIsoError::AvanzaOutOfBounds));
        assert_eq!(cis.donde, 11); 
    }
    
    #[test]
    fn test_special_char_mappings_sinc_s() {
        let mut cis = CadenaISO::from_bytes(&[129, 225, 129, 233, 97]); // áéa
        assert_eq!(cis.sinc(), Some("á".to_string()));
        assert_eq!(cis.s(), Some("á".to_string())); // donde = 2
        assert_eq!(cis.donde, 2);
        assert_eq!(cis.sinc(), Some("é".to_string()));
        assert_eq!(cis.s(), Some("é".to_string())); // donde = 4
        assert_eq!(cis.donde, 4);
        assert_eq!(cis.s(), Some("a".to_string())); // donde = 5
        assert_eq!(cis.donde, 5);
        assert_eq!(cis.s(), None);
    }

    #[test]
    fn test_incomplete_special_char() {
        let mut cis = CadenaISO::from_bytes(&[129]); // Just \129
        assert_eq!(cis.sinc(), Some(REPLACEMENT_CHAR.to_string()));
        assert_eq!(cis.s(), Some(REPLACEMENT_CHAR.to_string()));
        assert_eq!(cis.donde, 1);

        let mut cis2 = CadenaISO::from_bytes(&[97, 129]); // "a\129"
        cis2.s(); // consume 'a'
        assert_eq!(cis2.sinc(), Some(REPLACEMENT_CHAR.to_string()));
        assert_eq!(cis2.s(), Some(REPLACEMENT_CHAR.to_string()));
        assert_eq!(cis2.donde, 2);
    }
    
    #[test]
    fn test_unmapped_129_sequence() {
        let mut cis = CadenaISO::from_bytes(&[129, 100]); // \129d (d is not special)
        assert_eq!(cis.sinc(), Some(REPLACEMENT_CHAR.to_string())); // \129 becomes �
        assert_eq!(cis.s(), Some(REPLACEMENT_CHAR.to_string()));    // Consume \129
        assert_eq!(cis.donde, 1);
        assert_eq!(cis.s(), Some("d".to_string()));          // Consume 'd'
        assert_eq!(cis.donde, 2);
    }

    #[test]
    fn test_standard_utf8() {
        let mut cis = CadenaISO::from_str("ñ€好"); // ñ (2 bytes), € (3 bytes), 好 (3 bytes)
        assert_eq!(cis.s(), Some("ñ".to_string()));
        assert_eq!(cis.donde, 2);
        assert_eq!(cis.s(), Some("€".to_string()));
        assert_eq!(cis.donde, 5);
        assert_eq!(cis.s(), Some("好".to_string()));
        assert_eq!(cis.donde, 8);
        assert_eq!(cis.s(), None);
    }

    #[test]
    fn test_invalid_utf8_sequences() {
        let mut cis = CadenaISO::from_bytes(&[0xC3, 0x28]); // Invalid 2-byte seq (0x28 is not continuation)
        assert_eq!(cis.s(), Some(REPLACEMENT_CHAR.to_string())); // Invalid start byte C3 treated as error
        assert_eq!(cis.donde, 1); // Consumed C3
        assert_eq!(cis.s(), Some("(".to_string())); // 0x28 is '('

        let mut cis2 = CadenaISO::from_bytes(&[0xE2, 0x82, 0x28]); // Invalid 3-byte seq (0x28 is not continuation)
        assert_eq!(cis2.s(), Some(REPLACEMENT_CHAR.to_string()));
        assert_eq!(cis2.donde, 1); // Consumed E2
    }
    
    #[test]
    fn test_get2_with_mappings() {
        let cis = CadenaISO::from_bytes(&[129, 225, 129, 233, 97]); // áéa
        assert_eq!(cis.get2(), Some("áé".to_string()));
        
        let mut cis2 = CadenaISO::from_bytes(&[129, 225, 98]); // áb
        assert_eq!(cis2.get2(), Some("áb".to_string()));
        
        let mut cis3 = CadenaISO::from_bytes(&[99, 129, 237]); // cí
        assert_eq!(cis3.get2(), Some("cí".to_string()));

        let cis4 = CadenaISO::from_bytes(&[129, 225]); // á
        assert_eq!(cis4.get2(), None); // Only one char

        let cis5 = CadenaISO::from_str("a");
        assert_eq!(cis5.get2(), None);
    }

    #[test]
    fn test_sub_with_mappings_and_utf8() {
        // áb€c
        let cis = CadenaISO::from_bytes(&[129, 225, 98, 0xE2, 0x82, 0xAC, 99]); 
        assert_eq!(cis.sub(0, 7), Some("áb€c".to_string())); // Full string
        assert_eq!(cis.sub(0, 2), Some("á".to_string()));    // Just á
        assert_eq!(cis.sub(0, 3), Some("áb".to_string()));   // áb
        assert_eq!(cis.sub(2, 3), Some("b€".to_string()));  // b€ (b is 1 byte, € is 3 bytes, but length is 3 bytes)
                                                           // Expected: sub(2,1) -> "b", sub(3,3) -> "€"
                                                           // sub(start_byte_idx, byte_length)
        assert_eq!(cis.sub(2, 1), Some("b".to_string())); // "b"
        assert_eq!(cis.sub(3, 3), Some("€".to_string())); // "€"
        assert_eq!(cis.sub(0, 6), Some("áb€".to_string()));  // áb€

        // Test sub that splits a special char or UTF-8 sequence
        assert_eq!(cis.sub(0, 1), Some(REPLACEMENT_CHAR.to_string())); // Part of á
        assert_eq!(cis.sub(3, 1), Some(REPLACEMENT_CHAR.to_string())); // Part of € (E2)
        assert_eq!(cis.sub(3, 2), Some(REPLACEMENT_CHAR.to_string() + REPLACEMENT_CHAR)); // Part of € (E2, 82)
    }

    #[test]
    fn test_sub_edge_cases() {
        let cis = CadenaISO::from_str("test");
        assert_eq!(cis.sub(0, 0), Some("".to_string()));
        assert_eq!(cis.sub(4, 0), Some("".to_string()));
        assert_eq!(cis.sub(0, 10), None); // Length too long
        assert_eq!(cis.sub(5, 1), None);  // Start out of bounds
    }
}

[end of anmetrigal_rust/src/cadena_iso.rs]
