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

  # Enable networking for the live manual-installation environment.
  networking.networkmanager.enable = true;

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

  security.polkit.enable = true;

  # Use the standard temporary installation-media account.
  users.users.nixos.shell = pkgs.fish;
  services.getty.autologinUser = "nixos";

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
      home.stateVersion = lib.trivial.release;
    };
  };

  system.stateVersion = lib.trivial.release;
}
