# NixISO

NixISO is a reusable, AMD-focused NixOS live installer for performing a manual NixOS installation on compatible x86_64 desktops and laptops.

It provides a minimal graphical environment for following the upstream NixOS manual installation process:

- Niri, using the upstream default configuration without repository-managed changes.
- Alacritty, available in the live session and started automatically.
- LibreWolf, available in the live session and started automatically at the NixOS manual installation guide.
- Fish as the live installer's shell.
- NetworkManager for network connectivity during installation.
- The standard NixOS installer account, `nixos`, with automatic login in the live environment.
- Basic AMD hardware support: redistributable firmware, AMD CPU microcode, graphics support, and the latest kernel package set from the locked nixpkgs revision.
- Nix flakes and `nix-command` enabled in the live environment.

The ISO is an installation environment, not a preconfigured installed operating system.

## Project scope

This repository intentionally builds only the live installation ISO. It does not provide a default installed-system configuration for a laptop, desktop, or particular user.

After booting the ISO, users follow the official NixOS manual installation process and make their own choices about:

- Disk layout, filesystems, encryption, and swap.
- Bootloader and firmware configuration.
- Hostname, locale, timezone, users, and account setup.
- Desktop environment or window manager.
- Audio, Bluetooth, networking, power management, and printing.
- Applications, development tools, gaming, and other packages.
- NixOS modules, Home Manager, and personal dotfiles.

The repository does not impose a user account, installed-system login manager, installed-system shell, installed-system package set, Home Manager profile, or personal desktop configuration. The temporary `nixos` account and the applications configured through Home Manager exist only inside the live ISO.

Niri's configuration is not overridden. The ISO uses the default configuration supplied by the selected Niri package. It does not ship a `config.kdl`, custom keybindings, layouts, theme, or personal desktop settings.

## Repository layout

```text
NixISO/
├── .gitignore
├── README.md
├── flake.nix
├── flake.lock
├── docs/
│   └── REFERENCES.md
├── home/
│   └── iso.nix
├── hosts/
│   └── iso/
│       └── default.nix
└── modules/
    └── nixos/
        └── amd-hardware.nix
```

- `flake.nix`: exposes the ISO NixOS configuration and build output.
- `flake.lock`: pins exact nixpkgs and Home Manager revisions for reproducible builds.
- `hosts/iso/default.nix`: configures the temporary live installer environment.
- `modules/nixos/amd-hardware.nix`: contains only the AMD-oriented hardware settings used by this ISO.
- `home/iso.nix`: configures Fish, Alacritty, LibreWolf, and their live-session autostart entries for the temporary ISO account.
- `docs/REFERENCES.md`: links to the upstream NixOS, Nixpkgs, Niri, and Home Manager documentation.

Home Manager is used only to assemble the live ISO user's application environment. It is not a recommendation or requirement for the installed system users create.

## Build the ISO

On a NixOS x86_64-linux system with flakes enabled (or using the explicit feature flags below), clone this repository and build from its root:

```fish
nix --extra-experimental-features 'nix-command flakes' build .#packages.x86_64-linux.iso
```

The resulting ISO is available under:

```text
result/iso/
```

The build uses the exact dependency revisions recorded in `flake.lock`. Do not run `nix flake update` unless intentionally updating dependencies; after an update, rebuild and boot-test the ISO.

## Manual installation

1. Write the built ISO to a USB drive.
2. Boot the target x86_64 machine from that USB.
3. Connect to the network using the live environment.
4. Use Alacritty and LibreWolf in Niri to follow the [official NixOS manual installation guide](https://nixos.org/manual/nixos/unstable/#sec-installation-manual).
5. Partition and format disks according to your own requirements.
6. Mount the filesystems under `/mnt`.
7. Generate your machine's hardware configuration with `nixos-generate-config --root /mnt`.
8. Create your own NixOS configuration, or use your own flake/repository, and install it following the manual.

NixISO deliberately stops at providing the live environment. The installed system configuration belongs to the person performing the installation.

## AMD hardware scope

The ISO enables redistributable firmware, AMD CPU microcode updates, Linux graphics support, and the latest kernel package set available in the locked nixpkgs revision.

This is a general-purpose AMD-oriented starting point, not a guarantee that every AMD device or laptop feature works without additional configuration. Individual machines may require further firmware, kernel modules, or configuration for Wi-Fi, Bluetooth, suspend/resume, audio, hybrid graphics, and other hardware.

## Validation status

- **Live ISO:** Previously built successfully and boot-tested on the laptop. Automatic login, Fish, Niri, Alacritty, LibreWolf, and internet connectivity were observed working.
- **Laptop installed system:** This machine was installed and tested during development, but its personal host configuration is intentionally not part of this reusable template.
- **Desktop:** The same ISO is intended to be used on the desktop. A boot test on the desktop is still required before declaring the ISO tested on both target machines.

## Technical references

See [docs/REFERENCES.md](docs/REFERENCES.md) for upstream NixOS, Nixpkgs, Niri, and Home Manager documentation.
