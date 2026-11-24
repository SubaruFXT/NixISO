{ pkgs, ... }:

{
  # Applications available inside the live Niri installation session.
  home.packages = [
    pkgs.alacritty
    pkgs.librewolf
  ];

  # Configure the termfilechooser portal to run its packaged Yazi wrapper
  # inside Alacritty. Yazi itself is installed system-wide for the portal.
  home.file.".config/xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=yazi-wrapper.sh
    env=PATH=/run/current-system/sw/bin
    env=TERMCMD=${pkgs.alacritty}/bin/alacritty -e
  '';

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
