{ pkgs, ... }:

{
  programs.fish.enable = true;

  # Applications available inside the live Niri installation session.
  home.packages = [
    pkgs.alacritty
    pkgs.librewolf
  ];

  # These autostart entries apply only to the live ISO account.
  # They do not create defaults for the system users install later.
  home.file.".config/autostart/nixiso-alacritty.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Alacritty
    Exec=${pkgs.alacritty}/bin/alacritty
    Terminal=false
    X-GNOME-Autostart-enabled=true
  '';

  home.file.".config/autostart/nixiso-librewolf.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=LibreWolf
    Exec=${pkgs.librewolf}/bin/librewolf --new-window https://nixos.org/manual/nixos/unstable/#sec-installation-manual
    Terminal=false
    X-GNOME-Autostart-enabled=true
  '';
}
