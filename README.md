# NixISO

A reusable NixOS live installer and AMD-focused configuration base. It is intended for people with an AMD desktop and AMD laptop who want both installations to share the same operating-system and user modules, then maintain personal changes in their own fork.

The repository is a base/template. It does not contain an author's personal username, personal dotfiles, or machine-specific disk layout.

## What the ISO provides

The ISO is based on the upstream NixOS minimal installation image and adds only the requested desktop environment and applications:

- Niri, enabled through the native NixOS `programs.niri` module.
- The upstream Niri default configuration, unmodified.
- Fish as the shell.
- Alacritty.
- LibreWolf, opening the NixOS manual's manual-installation section.
- Automatic TTY login as the standard temporary `nixos` installation-media account.
- Niri starts from Fish's login-shell initialization on tty1. There is no display manager or graphical login screen.
- Git and the partitioning, networking, and filesystem utilities already supplied by the upstream NixOS installation image.

Alacritty and LibreWolf start automatically in the ISO session. The ISO's TTY autologin and application autostart do not belong to the installed desktop or laptop configuration.

## Niri configuration policy

Niri's configuration is deliberately not managed by this repository:

- No `config.kdl` is stored here.
- No Home Manager Niri configuration is declared.
- No `/etc/niri/config.kdl` is installed.
- No keybindings, layout settings, appearance settings, or other Niri defaults are overridden.

Niri therefore uses the default configuration embedded in the Niri package, as described by the [upstream configuration-loading documentation](https://niri-wm.github.io/niri/Configuration:-Introduction).

No optional application launcher, bar, or lock-screen program is added to the ISO. The upstream default configuration can reference optional programs that are not included in this base; those particular commands will not work. The Niri configuration itself remains untouched.

The NixOS Niri module's Nautilus integration is disabled to avoid adding an unrequested file manager; this does not modify Niri's KDL configuration.

## Shared AMD base

The reusable system module is `modules/nixos/amd-common.nix`. The host files under `hosts/desktop/` and `hosts/laptop/` import this same module. It contains settings intended to remain identical on both AMD machines:

- Latest kernel package set from nixpkgs unstable.
- AMD CPU microcode updates.
- Redistributable firmware support.
- Mesa graphics support.
- NetworkManager.
- Niri through the native NixOS module.
- Fish as the default shell for users whose shell is not explicitly set.
- Polkit.
- Nix flakes and the `nix-command` feature.
- Shared Home Manager package-set integration.

The shared Home Manager module is `home/common.nix`. It enables Fish and installs only Alacritty and LibreWolf. Import it for the personal user account in both installed host configurations.

The ISO uses the standard temporary `nixos` user provided by the NixOS installer profile. The name `nixos` is not a personal installed account. A personal username belongs in the user's own fork.

## Why both hosts and shared modules exist

The files under `hosts/` are per-machine entry points. They select which shared modules to import and contain the settings that genuinely differ between devices.

The file `modules/nixos/amd-common.nix` is not another host. It is the shared system module imported by both desktop and laptop. Without it, the common NixOS settings would have to be copied into both host files and could drift apart over time.

Each host still requires its own `hardware-configuration.nix`, generated on that machine, plus its own real bootloader and file-system settings.

## Fork-based workflow

1. Build and boot the live ISO.
2. Install NixOS manually using the NixOS manual.
3. Fork this repository for personal configuration.
4. Add each machine's generated hardware configuration, boot settings, personal user, and personal modules to the fork.
5. Keep `modules/nixos/amd-common.nix` and `home/common.nix` shared between desktop and laptop. Personal changes can be added in separate modules without duplicating the common files.

This keeps the base reusable for other AMD users while allowing each fork to maintain its own identity and preferences.

## Build the ISO

From the repository root on NixOS:

```fish
nix --extra-experimental-features 'nix-command flakes' flake lock
nix --extra-experimental-features 'nix-command flakes' build .#iso
```

The ISO appears under `result/iso/`.

Commit the generated `flake.lock` to Git after the first lock operation. It pins exact nixpkgs and Home Manager revisions for reproducible future builds. This configuration has been committed to GitHub but has not yet been evaluated or built; successful evaluation and ISO testing are still required.

## References

See [docs/REFERENCES.md](docs/REFERENCES.md) for the NixOS and Niri documentation used to design this base.
