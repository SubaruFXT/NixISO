{ pkgs, ... }:

{
  imports = [
    ../../modules/nixos/amd-common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "desktop";

  # UEFI boot using the existing systemd-boot setup.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Match the laptop's text login and Niri session startup.
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };

  # Enable remote administration for the subaru account.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      AllowUsers = [ "subaru" ];
    };
  };

  # Match the laptop's compressed in-memory swap configuration.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };

  users.users.subaru = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager.users.subaru = {
    imports = [
      ../../home/common.nix
    ];

    home.username = "subaru";
    home.homeDirectory = "/home/subaru";
    home.stateVersion = "26.11";
  };

  # Preserve the desktop's existing NixOS state compatibility value.
  system.stateVersion = "26.05";
}
