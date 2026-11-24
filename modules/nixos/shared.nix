{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics.enable = true;

  networking.networkmanager.enable = true;

  programs = {
    fish.enable = true;
    git.enable = true;
    niri = {
      enable = true;
      useNautilus = false;
    };
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = { };
  };

  users.users.subaru = {
    isNormalUser = true;
    description = "subaru";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.subaru.imports = [
      ../../home/subaru
    ];
  };
}
