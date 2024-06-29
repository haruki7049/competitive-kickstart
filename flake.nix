{
  description = "Rust environment for competitive programming";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ rust-overlay.overlays.default ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rustPlatform = pkgs.rustPlatform;
        fetchFromGitHub = pkgs.fetchFromGitHub;
        cargo-compete = rustPlatform.buildRustPackage rec {
          pname = "cargo-compete";
          version = "0.10.6";

          src = fetchFromGitHub {
            owner = "qryxip";
            repo = "cargo-compete";
            rev = "v${version}";
            sha256 = "sha256-trtnxWDXzCeZ7ICLbPgCrBFZZzOmpkGOjjrpus6t+is=";
          };

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            openssl.dev
            libiconv
          ] ++ lib.optionals stdenv.isDarwin [
            darwin.apple_sdk.frameworks.Security
          ];

          # OPENSSL_INCLUDE_DIR = (
          #   lib.makeSearchPathOutput "dev" "include" [ pkgs.openssl.dev ]
          # ) + "/openssl";

          # OPENSSL_STATIC = "0";

          cargoHash = "sha256-A8DAsbQDu9I8vEuDxBszADm45Q8NjnMDO8mD+ADl224=";

          doCheck = false;

          meta = with pkgs.lib; {
            description = "A Cargo subcommand for competitive programming";
            maintainers = with maintainers; [ aspulse ];
          };
        };
        cargo-equip = rustPlatform.buildRustPackage rec {
          pname = "cargo-equip";
          version = "0.20.1";

          src = fetchFromGitHub {
            owner = "qryxip";
            repo = "cargo-equip";
            rev = "v${version}";
            sha256 = "sha256-yxRiG96jC7zdlMQpL0B9Mle2kD1TOhqTZzMX3I8IE9I=";
          };

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            openssl.dev
            libiconv
          ];

          cargoHash = "sha256-CMCmWQZksAXXQZ4QhWv6jnZqsfLy+1+/6WjWQGSCZCI=";

          doCheck = false;

          meta = with pkgs.lib; {
            description = "A Cargo subcommand to bundle your code into one `.rs` file for competitive programming";
            maintainers = with maintainers; [ aspulse ];
          };
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.rustup
            pkgs.cargo-udeps
            cargo-compete
            cargo-equip
          ];
          shellHook = ''
            exec $SHELL
          '';
        };
      }
    );
}
