{
  description = "CNG video essay content generation dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python313;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            python
            pkgs.uv
          ];

          shellHook = ''
            export VIRTUAL_ENV="$PWD/.venv"
            export PIP_CACHE_DIR="$PWD/.pip-cache"
            export PATH="$VIRTUAL_ENV/bin:$PATH"
          '';
        };
      });
}