
## Pre-requisites:
- Opam 1.2.2: `sudo apt get opam` and then ` opam switch an-metri-gal --alias-of 4.02.3`
- Ocaml 4.02.3 will be installed now
- Dune 1.2.1: `opam install dune`

## Steps:
- Install Ocaml, Opam and Dune in the versions mentioned. See https://medium.com/@bobbypriambodo/starting-an-ocaml-app-project-using-dune-d4f74e291de8
- type `cd src` 
- Type 
```sh
eval `opam config env`
```
- Type `dune build main.exe`
- See results in `./_build/default`directory
