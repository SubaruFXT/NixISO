{ pkgs, ... }:

{
  imports = [
    ../../modules/nixos/amd-common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop";

  # UEFI boot using the EFI System Partition mounted at /boot.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Provide a text login prompt and start the Niri session after authentication.
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };

  # This installation uses disk swap for overflow and ZRAM for compressed
  # in-memory swap. Hibernation is not configured.
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

  system.stateVersion = "26.11";
}
