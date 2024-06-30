{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ rust-overlay.overlays.default ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        cargo-compete = pkgs.callPackage ./cargo-compete.nix {};
        cargo-equip = pkgs.callPackage ./cargo-equip.nix {};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.rustup pkgs.cargo-udeps cargo-compete cargo-equip ];
        };

        shellHook = ''
          exec $SHELL
        '';
      });
}
