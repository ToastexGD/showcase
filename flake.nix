{
  description = "Showcase GD Mod";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/a84ebe20c6bc2ecbcfb000a50776219f48d134cc";
    flake-utils.url = "github:numtide/flake-utils";
    microvm.url = "github:flafydev/microvm.nix/2dd8d4559aae92880ddc7d6367015f970b16455c";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    microvm,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages = {
        showcase-server = pkgs.callPackage ./server/nix/package.nix {};
        vm-package-recipe = import ./server/nix/vm-package.nix {
          inherit nixpkgs microvm;
        };
      };
      devShells = {
        server = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            dart
            wineWowPackages.unstable
            cage
          ];
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.sqlite.out}/lib"
          '';
        };
      };
    })
    // {
      overlays.default = _final: prev: {
        showcase-server = prev.callPackage ./server/nix/package.nix {};
      };
      nixosModules = {
        default = import ./server/nix/module.nix self;
      };
    };
}
