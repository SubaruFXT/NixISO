{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../../modules/nixos/shared.nix
  ];

  networking.hostName = "nixiso";

  # The installation-CD profile normally autologs into the nixos TTY user.
  # Disable that path so greetd is the only automatic session startup.
  services.getty.autologinUser = lib.mkForce null;

  services.greetd = {
    enable = true;
    restart = false;

    settings = {
      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "subaru";
      };

      default_session = {
        command = "${pkgs.greetd}/bin/agreety --cmd ${pkgs.niri}/bin/niri-session";
        user = "greeter";
      };
    };
  };

  # The live ISO user is temporary and has no password.
  users.users.subaru.initialHashedPassword = "";

  home-manager.users.subaru.imports = [
    ../../home/iso.nix
  ];

  system.stateVersion = "26.05";
}
