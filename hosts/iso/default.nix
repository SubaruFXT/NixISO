{ lib, modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../../modules/nixos/amd-hardware.nix
  ];

  networking.hostName = "nixiso";

  # Keep ZFS out of the live ISO because the latest kernel package set
  # does not provide the matching ZFS module set.
  boot.supportedFilesystems.zfs = lib.mkForce false;

  # Enable flakes in the live installer so users can build their own
  # configurations from Git repositories during manual installation.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # The installer provides a minimal Niri session and Fish shell.
  programs = {
    fish.enable = true;
    niri = {
      enable = true;
      useNautilus = false;
    };
  };

  # Use Yazi as the XDG FileChooser portal backend.
  # Alacritty is used as the terminal for the Yazi chooser session.
  environment.systemPackages = [ pkgs.yazi ];

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
    config.niri."org.freedesktop.impl.portal.FileChooser" =
      lib.mkForce "termfilechooser";
  };

  # Use the standard temporary installation-media account with Fish.
  users.users.nixos.shell = pkgs.fish;

  # Start Niri on the automatically logged-in installer TTY.
  # -l prevents niri-session from starting an additional login shell.
  programs.fish.loginShellInit = ''
    if test (tty) = /dev/tty1
      niri-session -l
    end
  '';

  # Home Manager is used only for the live ISO session's applications.
  # It does not define an installed-system user configuration.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.nixos = {
      imports = [ ../../home/iso.nix ];
      home.username = "nixos";
      home.homeDirectory = "/home/nixos";
      home.stateVersion = "26.11";
    };
  };

  system.stateVersion = "26.11";
}
