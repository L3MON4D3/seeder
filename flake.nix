{
  description = "Empty nix flake.";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, ... }@inputs : flake-utils.lib.eachDefaultSystem(system: let
    pkgs = import inputs.nixpkgs-unstable { inherit system; };
    iso639-lang = pkgs.python3Packages.buildPythonApplication rec {
      pname = "kiwix-seeder";
      version = "0.0.1";
      pyproject = true;

      src = pkgs.fetchFromGitHub {
        owner = "LBeaudoux";
        repo = "iso639";
        rev = "a3c0e413b6b17b22410364b52b49e4d7f7df655c";
        hash = "sha256-NnJyDr3ghZu2JN7kWqxt4anQO/ZR6DEI2u9A1Y1oLrM=";
      };
      build-system = with pkgs.python3Packages; [setuptools];
    };
  in {
    packages.default = pkgs.python3Packages.buildPythonApplication rec {
      pname = "kiwix-seeder";
      version = "0.0.1";
      pyproject = true;

      src = ./.;

      build-system = with pkgs.python3Packages; [hatchling];
      dependencies = with pkgs.python3Packages; [
        qbittorrent-api
        invoke
        humanfriendly
        requests
        rich-argparse
        xmltodict
      ] ++ [ iso639-lang ];
    };
  });
}
