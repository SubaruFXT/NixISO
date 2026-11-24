# NixISO

A NixOS live-installer configuration with shared system and user modules intended for the desktop and laptop installations. Reproducible builds require the generated `flake.lock` to be committed.

## Current implementation

This first configuration stage defines an x86_64 NixOS live ISO and the shared configuration modules that will also be used by the installed systems. It has been committed to GitHub but has not yet been evaluated or built on a NixOS machine. The desktop and laptop host configurations are deliberately not declared yet: their generated hardware configurations and boot requirements must be captured from the actual machines rather than guessed.

## Live ISO

The ISO is based on the upstream NixOS minimal installation image and adds:

- Niri, enabled through the native NixOS `programs.niri` module.
- The upstream Niri default configuration, unmodified.
- Fish as the `subaru` user's shell.
- Alacritty and LibreWolf.
- Waybar, which the upstream Niri default configuration starts automatically.
- Swaylock, which the upstream default configuration binds to `Super+Alt+L`, with its PAM service enabled.
- greetd configured to start Niri automatically as `subaru`.
- Alacritty and LibreWolf automatically started through ISO-only XDG autostart desktop entries.
- The NixOS manual's manual-installation section opened in LibreWolf.
- Git and the standard installation tools supplied by the upstream NixOS installation image.
- GitHub CLI on the live ISO so the private NixISO repository can be authenticated and cloned.

The upstream installer profile also enables NetworkManager and supplies the normal disk and filesystem utilities. NixISO builds on those defaults instead of replacing them.

### Niri default configuration is intentionally not managed here

There is no Niri `config.kdl` in this repository. Home Manager does not generate or install one, and the ISO does not install an `/etc/niri/config.kdl`. When Niri first starts, it therefore creates its own embedded upstream default configuration in the live user's home directory.

The default configuration is not edited to remove or replace any keybinding. Fuzzel is intentionally not installed. As a result, the unmodified `Super+D` default binding still attempts to launch Fuzzel and will not work. No alternative launcher is installed.

The native NixOS Niri module's Nautilus integration is disabled; this does not change Niri's KDL configuration.

### Automatic login scope

greetd's automatic Niri session exists only in `hosts/iso/default.nix`. The shared system module does not configure automatic login, and the installed desktop and laptop will use normal login.

The ISO disables the installation profile's automatic text-console login so greetd is the only automatic session startup path.

## Shared configuration

The shared NixOS module enables:

- Niri through the native NixOS module.
- Fish and sets it as the `subaru` user's shell.
- NetworkManager.
- Mesa graphics support for the supported AMD and Intel graphics stack.
- The latest kernel package set from the selected nixpkgs input.
- Polkit and the PAM service required by the default Swaylock binding.
- Nix flakes and the `nix-command` feature.

The shared Home Manager module installs Alacritty, LibreWolf, Waybar, and Swaylock for `subaru`. These are shared with the future installed desktop and laptop configurations. The ISO-specific Home Manager module adds GitHub CLI and the two live-session application autostart entries.

Home Manager uses `useGlobalPkgs = true` and `useUserPackages = true`, and its nixpkgs input follows the flake's nixpkgs input.

## Build the ISO

From the repository root on NixOS:

```fish
nix --extra-experimental-features 'nix-command flakes' flake lock
nix --extra-experimental-features 'nix-command flakes' build .#iso
```

The resulting ISO is under `result/iso/`.

Commit `flake.lock` to Git after the first lock operation. That lock file pins the exact nixpkgs and Home Manager revisions used by subsequent builds. Updating those inputs should be an intentional, reviewed operation.

## Manual installation and host configurations

The live ISO provides the environment for manual partitioning and installation. It does not guess the target machine's disk layout, firmware mode, bootloader, or hardware configuration.

The installed desktop and laptop are not yet exposed as flake configurations. Before adding them, generate and review the hardware configuration on each actual machine and confirm the machine-specific boot settings and `system.stateVersion`. The desktop's existing NixOS state version is 26.05 and should be preserved. The laptop's state version must be established from that machine rather than assumed.

The shared modules in `modules/nixos/shared.nix` and `home/subaru/` are intended to be imported by both installed host configurations. The ISO-only greetd login and application autostart module must not be imported into those host configurations.

Because this GitHub repository is private, authenticate in the live ISO with `gh auth login` before cloning it.

## References

See [docs/REFERENCES.md](docs/REFERENCES.md) for the NixOS and Niri documentation used to design this configuration.
