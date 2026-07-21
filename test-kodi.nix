{ pkgs ? import <nixpkgs> {} }:
pkgs.kodi.withPackages (p: [ pkgs.python3Packages.pycryptodome ])
