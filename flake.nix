{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ "x86_64-linux" ];
      perSystem = { pkgs, ... }:
        ############################ PACKAGES ############################
        let
          ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_3;
          extunix = ocamlPackages.buildDunePackage {
            pname = "extunix";
            version = "20250621.0";
            minimumOCamlVersion = "4.13";
            src = ./.;
            nativeBuildInputs = with ocamlPackages; [ findlib ocaml ];

            buildInputs = with ocamlPackages; [
              ocaml
              findlib
              ppxlib
              dune-configurator
            ];
          };
        in {
          packages.default = extunix;

          devShells.default = pkgs.mkShell {
            inputsFrom = [ extunix ];
          };
        };
    };
}
