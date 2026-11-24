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
}
