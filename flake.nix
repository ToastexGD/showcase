{
  description = "Showcase GD Mod";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/4aa36568d413aca0ea84a1684d2d46f55dbabad7";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages = {
        showcase-server = pkgs.callPackage ./server/nix/package.nix {};
      };
      devShells = {
        server = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            dart
            wineWowPackages.unstable
            # cage
          ];
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.sqlite.out}/lib"
          '';
        };
      };
    });
}
