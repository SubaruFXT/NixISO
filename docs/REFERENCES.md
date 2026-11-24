# NixISO technical references

These sources guide the configuration. When behavior or option names are uncertain, prefer the current NixOS module implementation and current Niri documentation over assumptions or older tutorials.

## NixOS

- [NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_Wiki)
- [NixOS unstable manual](https://nixos.org/manual/nixos/unstable/)
- [NixOS manual: Manual Installation](https://nixos.org/manual/nixos/unstable/#sec-installation-manual)
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS GitHub organization](https://github.com/NixOS/)
- [Nixpkgs Niri module](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/wayland/niri.nix)
- [Nixpkgs greetd module](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/display-managers/greetd.nix)
- [Nixpkgs installation CD base module](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/installer/cd-dvd/installation-cd-base.nix)
- [Nixpkgs minimal installation image module](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix)

## Niri

- [Niri documentation](https://niri-wm.github.io/niri/)
- [Niri source repository](https://github.com/niri-wm/niri/)
- [Niri wiki](https://github.com/niri-wm/niri/wiki)
- [Niri upstream default configuration](https://github.com/niri-wm/niri/blob/main/resources/default-config.kdl)
- [Niri configuration loading behavior](https://niri-wm.github.io/niri/Configuration:-Introduction)
- [Niri autostart documentation](https://niri-wm.github.io/niri/Configuration:-Miscellaneous#spawn-at-startup)

## Home Manager

- [Home Manager source repository](https://github.com/nix-community/home-manager)
- [Home Manager NixOS module](https://github.com/nix-community/home-manager/tree/master/nixos)

## Configuration policy

- Niri is enabled with the native NixOS `programs.niri` module.
- This repository intentionally does not create or manage `config.kdl`.
- The ISO does not install `/etc/niri/config.kdl`.
- Niri therefore uses the upstream default configuration embedded in the Niri package.
- The ISO does not install Fuzzel. The upstream default `Super+D` binding remains unchanged and will not launch an application unless Fuzzel is installed separately.
- ISO-only automatic application startup is handled outside Niri's configuration using desktop autostart entries.
