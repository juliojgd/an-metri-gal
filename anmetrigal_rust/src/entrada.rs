// Rust translation of src/lib/entrada.ml

use std::fs::File;
use std::io::{self, BufRead, BufReader};

/// Opens a file, returning a Result.
/// OCaml equivalent: `let fin nomfich = try open_in nomfich with | Sys_error _ -> (print_string ("Erro abrindo o ficheiro: "^nomfich); exit 0);;`
/// This Rust version returns the error to the caller instead of exiting directly.
pub fn abrir_ficheiro(nomfich: &str) -> Result<File, io::Error> {
    File::open(nomfich)
}

/// Reads all lines from a file into a list of strings.
/// OCaml equivalent: `let haz_lista st = let fich=fin st in let rec itera lista= let l=linea fich in if l="FINFICH" then lista else itera (l::lista) in List.rev (itera []);;`
///
/// In Rust, this function takes a filename and returns a `Result<Vec<String>, String>`.
/// If an error occurs opening or reading the file, it returns `Err` with a message similar to the OCaml version.
pub fn haz_lista(nomfich: &str) -> Result<Vec<String>, String> {
    // Attempt to open the file using the helper function
    let file = match abrir_ficheiro(nomfich) {
        Ok(f) => f,
        Err(e) => {
            // Mimic OCaml error message and exit behavior by returning an error string for main to handle
            return Err(format!("Erro abrindo o ficheiro {}: {}", nomfich, e));
        }
    };

    // Create a BufReader to efficiently read lines
    let reader = BufReader::new(file);

    // Collect lines into a Vec<String>.
    // The OCaml version prepends lines and then reverses; `collect()` naturally gives the correct order.
    // Errors during line reading are also handled.
    match reader.lines().collect() {
        Ok(lines) => Ok(lines),
        Err(e) => {
            // Error reading lines
            Err(format!("Erro lendo liñas do ficheiro {}: {}", nomfich, e))
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    use std::io::Write;

    // Helper to create a temporary file with specified content
    fn create_temp_file(name: &str, content: &str) -> std::path::PathBuf {
        let path = std::env::temp_dir().join(name);
        let mut file = fs::File::create(&path).expect("Failed to create temp file for testing");
        write!(file, "{}", content).expect("Failed to write to temp file for testing");
        path
    }

    #[test]
    fn test_abrir_ficheiro_success() {
        let test_file_path = create_temp_file("test_open_success.txt", "hello");
        assert!(abrir_ficheiro(test_file_path.to_str().unwrap()).is_ok());
        fs::remove_file(test_file_path).expect("Failed to remove temp file");
    }

    #[test]
    fn test_abrir_ficheiro_failure() {
        // Attempt to open a non-existent file
        let result = abrir_ficheiro("non_existent_file_for_rust_test.txt");
        assert!(result.is_err());
    }

    #[test]
    fn test_haz_lista_success() {
        let content = "linea 1\nlinea 2\nlinea 3";
        let test_file_path = create_temp_file("test_haz_lista_success.txt", content);
        
        let expected_lines = vec![
            "linea 1".to_string(),
            "linea 2".to_string(),
            "linea 3".to_string(),
        ];

        match haz_lista(test_file_path.to_str().unwrap()) {
            Ok(lines) => assert_eq!(lines, expected_lines),
            Err(e) => panic!("haz_lista failed unexpectedly: {}", e),
        }
        fs::remove_file(test_file_path).expect("Failed to remove temp file");
    }

    #[test]
    fn test_haz_lista_empty_file() {
        let test_file_path = create_temp_file("test_haz_lista_empty.txt", "");
        let expected_lines: Vec<String> = Vec::new();

        match haz_lista(test_file_path.to_str().unwrap()) {
            Ok(lines) => assert_eq!(lines, expected_lines),
            Err(e) => panic!("haz_lista failed for empty file: {}", e),
        }
        fs::remove_file(test_file_path).expect("Failed to remove temp file");
    }

    #[test]
    fn test_haz_lista_file_open_error() {
        let result = haz_lista("another_non_existent_file_for_rust_test.txt");
        assert!(result.is_err());
        if let Err(e_msg) = result {
            assert!(e_msg.starts_with("Erro abrindo o ficheiro another_non_existent_file_for_rust_test.txt:"));
        }
    }

    // Note: Testing for line reading errors is harder to set up reliably,
    // as it usually involves specific I/O issues or malformed UTF-8 if not reading raw bytes.
    // The current implementation of `haz_lista` using `reader.lines().collect()`
    // will catch UTF-8 errors if the file contains invalid UTF-8.
}
