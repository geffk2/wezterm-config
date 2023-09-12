{system ? builtins.currentSystem, pkgs ? import <nixpkgs> {}}:
  pkgs.stdenv.mkDerivation {
    name = "katja-wezterm";

    builder = "${pkgs.bash}/bin/bash";
    args = [ ./builder.sh ];

    fennel = pkgs.luajitPackages.fennel;
    coreutils = pkgs.coreutils;

    src = ./.;
    entrypoint = "init.fnl";

    # system = builtins.currentSystem;
    system = system;
  }
