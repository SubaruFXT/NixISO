{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../../modules/nixos/amd-common.nix
  ];

  networking.hostName = "nixiso";

  # Use the standard temporary NixOS installation-media account.
  # The ISO profile already creates this account with wheel access and
  # an empty password. It is not a personal account from any user's fork.
  users.users.nixos.shell = pkgs.fish;

  # Disable the installation image's TTY autologin so greetd starts
  # the graphical live session instead.
  services.getty.autologinUser = lib.mkForce null;

  services.greetd = {
    enable = true;
    restart = false;

    settings = {
      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "nixos";
      };

      default_session = {
        command = "${pkgs.greetd}/bin/agreety --cmd ${pkgs.niri}/bin/niri-session";
        user = "greeter";
      };
    };
  };

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
