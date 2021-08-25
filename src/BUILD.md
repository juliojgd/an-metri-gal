
## Pre-requisites:
- Opam 1.2.2: `sudo apt get opam` and then ` opam switch an-metri-gal --alias-of 4.06.1`
- Ocaml 4.06.1 will be installed now
- Dune 1.2.1: `opam install dune`

## Steps with Dune
- Install Ocaml, Opam and Dune in the versions mentioned. See https://medium.com/@bobbypriambodo/starting-an-ocaml-app-project-using-dune-d4f74e291de8
- type `cd src` 
- Type 
```sh
eval `opam config env`
```
- Type `dune build main.exe`
- See results in `./_build/default`directory


## Steps with Esy
- Install Esy following: https://esy.sh/docs/en/getting-started.html
- type `cd src` 
- Type `esy install`
- Type `esy build`
- See results in `_esy/default/store/b/an_metri_gal-7ed22e74/install/default/` directory
