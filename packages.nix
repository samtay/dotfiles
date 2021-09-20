let
  pkgs = import ./. {};
  pkgs-20-09 = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/cd63096d6d887d689543a0b97743d28995bc9bc3.tar.gz") {};
in
  [ # These are required by nix itself
    pkgs.pkgs.cacert
    pkgs.pkgs.nix

    # Tools that we use; these will be pinned to the same versions as run in CI
    pkgs.pkgs.minio
    pkgs.pkgs.postgresqlWithPackages
    pkgs-20-09.stack
    pkgs.pkgs.yarn
    pkgs.pkgs.stow
  ]

