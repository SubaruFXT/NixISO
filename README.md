# NixISO

A NixOS live installer and AMD-focused configuration for a desktop and laptop. Both installed systems share the same operating-system and Home Manager modules, while machine-specific hardware and boot settings stay in each host directory.

## What the ISO provides

The ISO is based on the upstream NixOS minimal installation image and adds:

- Niri, enabled through the native NixOS `programs.niri` module.
- The upstream Niri default configuration, unmodified.
- Fish as the shell.
- Alacritty and LibreWolf, with LibreWolf opening the NixOS manual's manual-installation section.
- Automatic TTY login as the standard temporary `nixos` installation-media account.
- Niri launched from Fish's login-shell initialization on tty1 using `niri-session -l`, preventing the session launcher from starting another login shell.
- The Git and partitioning, networking, and filesystem utilities supplied by the upstream installer image.

Alacritty and LibreWolf start automatically in the ISO session. The ISO's temporary account and application autostart do not carry over to installed systems.

## Niri configuration policy

Niri's configuration is deliberately not managed by this repository:

- No `config.kdl` is stored here.
- No Home Manager Niri configuration is declared.
- No `/etc/niri/config.kdl` is installed.
- No keybindings, layout settings, appearance settings, or other Niri defaults are overridden.

Niri uses the default configuration embedded in the selected Niri package. The NixOS Niri module's Nautilus integration is disabled to avoid adding an unrequested file manager. Optional programs referenced by Niri's default configuration are not added to this base, so the corresponding optional commands may be unavailable.

## Shared AMD base

`modules/nixos/amd-common.nix` contains settings shared by both AMD hosts:

- Latest kernel package set from nixpkgs unstable.
- AMD CPU microcode updates and redistributable firmware support.
- Linux graphics support.
- NetworkManager.
- Niri through the native NixOS module.
- Fish as the default shell.
- Polkit.
- Nix flakes and the `nix-command` feature.
- Shared Home Manager package-set integration.

The shared Home Manager module is `home/common.nix`. It enables Fish and installs Alacritty and LibreWolf. The ISO adds its own application autostart entries in `home/iso.nix`.

## Host configurations

- **ISO:** `hosts/iso/default.nix` builds the tested live installer.
- **Laptop:** `hosts/laptop/default.nix` is configured for the detected UEFI laptop hardware. Its generated `hardware-configuration.nix` records the actual EFI, root, and swap filesystem UUIDs. It uses systemd-boot, 4 GiB disk swap, and ZRAM. OpenSSH is enabled for the `subaru` account; root SSH login is disabled.
- **Desktop:** `hosts/desktop/default.nix` is a template only. Its generated hardware configuration and boot settings still need to be captured from the desktop before it can be exposed as a flake host output.

The laptop's installed system uses the established account name `subaru`. No password or password hash is stored in this repository; the account password is configured locally.

Each machine has its own `system.stateVersion` and generated hardware file. Do not copy one machine's hardware configuration to the other.

## Build the ISO

From the repository root on NixOS:

```fish
nix --extra-experimental-features 'nix-command flakes' build .#packages.x86_64-linux.iso
```

The ISO appears under `result/iso/`.

## Evaluate the laptop configuration

```fish
nix --extra-experimental-features 'nix-command flakes' eval .#nixosConfigurations.laptop.config.system.build.toplevel.drvPath
```

To install from a checkout of this repository, follow the [NixOS manual installation guide](https://nixos.org/manual/nixos/unstable/#sec-installation-manual) and build the laptop flake configuration as `.#laptop` from the repository root.

## Dependency updates

The committed `flake.lock` pins exact nixpkgs and Home Manager revisions. Run `nix --extra-experimental-features 'nix-command flakes' flake update` only when intentionally updating dependencies, then evaluate and build the configurations again.

## Validation status

- **ISO:** Built successfully and boot-tested on the laptop. The live session's automatic login, Fish, Niri, Alacritty, LibreWolf, and internet access were tested.
- **Laptop build:** The complete `nixosConfigurations.laptop.config.system.build.toplevel` derivation built successfully using the committed flake lock.
- **Laptop installation:** Installed to the laptop's internal Samsung 990 PRO SSD and booted successfully.
- **Laptop services:** `sshd`, `greetd`, and `NetworkManager` were confirmed active on the installed system.
- **Laptop applications:** Niri, Alacritty, and LibreWolf executables were found in the installed system and user profile.
- **Laptop graphics and Wi-Fi drivers:** Both AMD graphics devices (Radeon RX 6500M/Navi 24 and integrated Radeon Vega/Cezanne) were observed using the `amdgpu` kernel driver. The MediaTek MT7922 adapter was observed using `mt7921e`.
- **Laptop memory:** 7.5 GiB ZRAM and the 4 GiB disk swap partition were active; no swap was in use at the time of inspection.
- **Desktop:** Not yet configured as a buildable flake host. Its hardware configuration must be generated from the actual desktop before adding the desktop output.

Driver binding was verified with `lspci -nnk`; this does not by itself test every graphics feature, Bluetooth, suspend/resume, or Wi-Fi reliability under load.

## Technical references

See [docs/REFERENCES.md](docs/REFERENCES.md) for the NixOS and Niri documentation used to design this configuration.
