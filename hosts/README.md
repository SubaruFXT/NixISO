# Host configurations

The host directories contain machine-specific entry points. Both installed machines should import the same common modules:

- `modules/nixos/amd-common.nix`
- `home/common.nix` for the personal account

Keep machine-specific hardware in that machine's generated `hardware-configuration.nix`. Never copy filesystem UUIDs, kernel modules, or mount settings between machines.

## Laptop

The laptop host is configured as the first installed system. It contains:

- The generated hardware configuration from the laptop's current UEFI live session.
- systemd-boot with the EFI System Partition mounted at `/boot`.
- 4 GiB disk swap plus ZRAM.
- The `subaru` user, in the `wheel` and `networkmanager` groups.
- The shared Home Manager applications and Fish shell.

No password or password hash is stored in Git. Set the account password locally during installation.

## Desktop

The desktop host remains a template until its own generated hardware configuration and boot settings have been captured and evaluated. Do not point the desktop flake output at the laptop hardware file.

## State versions

The laptop's initial NixOS and Home Manager state versions are both `26.11`. After installation, these values should be treated as compatibility settings and should not be changed casually during upgrades.
