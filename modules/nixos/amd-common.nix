{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware = {
    enableRedistributableFirmware = true;
    graphics.enable = true;
    cpu.amd.updateMicrocode = true;
  };

  networking.networkmanager.enable = true;

  programs = {
    fish.enable = true;
    niri = {
      enable = true;
      useNautilus = false;
    };
  };

  users.defaultUserShell = pkgs.fish;

  security.polkit.enable = true;

  # Home Manager is imported by the flake. Keep its package set aligned
  # with the system package set for all hosts using this shared module.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
