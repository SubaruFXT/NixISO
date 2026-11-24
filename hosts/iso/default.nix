{ lib, modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../../modules/nixos/amd-common.nix
  ];

  networking.hostName = "nixiso";

  # Use the standard temporary account provided by the NixOS installer.
  users.users.nixos.shell = pkgs.fish;

  # Log in directly on tty1. No display manager or graphical greeter.
  services.getty.autologinUser = "nixos";

  # Start the Niri session from the automatically logged-in Fish shell.
  # If Niri exits, control returns to the Fish prompt on tty1.
  programs.fish.loginShellInit = ''
    if test (tty) = /dev/tty1
      niri-session
    end
  '';

  home-manager.users.nixos = {
    imports = [
      ../../home/common.nix
      ../../home/iso.nix
    ];

    home.username = "nixos";
    home.homeDirectory = "/home/nixos";
    home.stateVersion = lib.trivial.release;
  };

  system.stateVersion = lib.trivial.release;
}
