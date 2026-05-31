
## Pre-requisites:
- Opam 2.1.2: 
   * `sudo apt install opam`
   * `opam switch create 5.2.1`
   * `opam --version` should output `2.1.2`
- Ocaml 5.2.1 will be installed now
   * `ocaml --version` should output: `OCaml version 5.2.1`
- Dune 3.4.1: 
   * `opam install dune`
   * `dune --version` should output `3.17.0`
 


## Steps with Dune
- Install Ocaml, Opam and Dune in the versions mentioned. See https://medium.com/@bobbypriambodo/starting-an-ocaml-app-project-using-dune-d4f74e291de8
- Alternatively install Ocaml with asdf: https://github.com/asdf-community/asdf-ocaml
- At repository root, run:
```sh
eval "$(opam env)"
dune build
dune test
```
- The executable is generated in `_build/default/bin/anmetrigal.exe`.

## Steps with Esy
- Install asdf: https://asdf-vm.com/guide/getting-started.html
- Install asdf nodejs plugin: asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
- Install a node&npm version: asdf install nodejs 23.3.0
```sh
$ node -v
v23.3.0
```

```sh
$ npm --version
10.9.0
```

- Install Esy following: https://esy.sh/docs/en/getting-started.html
- npm install -g esy
- `esy --version` should output `0.8.0`
- Type `esy install`
- Type `esy build`
- See results in `_esy/default/store/b/an_metri_gal-7ed22e74/install/default/` directory
