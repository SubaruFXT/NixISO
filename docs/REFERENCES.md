# NixISO technical references

These are the primary references for this configuration. The repository intentionally follows native NixOS and Niri mechanisms rather than copying an unrelated desktop configuration.

## NixOS

- [NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_Wiki)
- [NixOS unstable manual](https://nixos.org/manual/nixos/unstable/)
- [NixOS manual: Manual Installation](https://nixos.org/manual/nixos/unstable/#sec-installation-manual)
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS GitHub organization](https://github.com/NixOS/)
- [Nixpkgs Niri module](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/wayland/niri.nix)
- [Nixpkgs Fish module](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/fish.nix)
- [Nixpkgs installation-device profile](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/profiles/installation-device.nix)
- [NixOS TTY compositor startup example](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/tests/tinywl.nix)
- [Nixpkgs installation CD base module](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/installer/cd-dvd/installation-cd-base.nix)
- [Nixpkgs minimal installation image module](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix)

## Niri

- [Niri documentation](https://niri-wm.github.io/niri/)
- [Niri source repository](https://github.com/niri-wm/niri/)
- [Niri wiki](https://github.com/niri-wm/niri/wiki)
- [Niri upstream default configuration](https://github.com/niri-wm/niri/blob/main/resources/default-config.kdl)
- [Niri configuration loading behavior](https://niri-wm.github.io/niri/Configuration:-Introduction)
- [Niri getting started](https://niri-wm.github.io/niri/Getting-Started)

## Yazi and XDG file chooser

- [Yazi documentation: using Yazi as your system file chooser](https://yazi-rs.github.io/docs/tips/#yazi-as-your-system-file-chooser)
- [xdg-desktop-portal-termfilechooser source repository](https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser)
- [Nixpkgs package: xdg-desktop-portal-termfilechooser](https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/by-name/xd/xdg-desktop-portal-termfilechooser)
- [XDG Desktop Portal FileChooser interface](https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.impl.portal.FileChooser.html)

## Home Manager

- [Home Manager source repository](https://github.com/nix-community/home-manager)
- [Home Manager NixOS module](https://github.com/nix-community/home-manager/tree/master/nixos)

## Configuration policy

Niri is enabled using the native NixOS `programs.niri` module. This repository does not create or manage a Niri KDL configuration. In particular, it does not install `config.kdl` under either the user's home directory or `/etc/niri/`. Niri uses the default configuration embedded in the selected Niri package.

Optional programs referenced by Niri's default configuration are intentionally not added to this base. Those commands remain exactly as shipped upstream, but the corresponding optional functionality is unavailable when its executable is not installed.

The live ISO uses the standard `nixos` installation-media account. Getty automatically logs it in on tty1, and the NixOS Fish `loginShellInit` hook launches `niri-session -l` from that TTY. The `-l` argument tells the session launcher not to start another login shell. No display manager or graphical greeter is configured.

Alacritty and LibreWolf autostart are configured independently through XDG desktop-autostart entries in the live ISO user's Home Manager profile. This does not modify Niri's configuration.

Niri's XDG FileChooser portal is routed to `xdg-desktop-portal-termfilechooser`, using its packaged Yazi wrapper. The wrapper launches Yazi in Alacritty, configured through the live ISO user's Home Manager file. The GTK portal remains available for other portal interfaces but is not selected for Niri's FileChooser interface. This only affects applications that use the XDG FileChooser portal; application-specific support and preferences can vary.
