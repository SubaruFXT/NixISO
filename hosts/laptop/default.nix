{ ... }:

{
  imports = [
    ../../modules/nixos/amd-common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop";
}
