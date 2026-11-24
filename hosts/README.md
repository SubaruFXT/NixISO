# Host configurations

The desktop and laptop both import the same AMD system module:

- `modules/nixos/amd-common.nix`
- `home/common.nix` (import this for the account used on each installed system)

Keep shared operating-system behavior and shared user applications in those files. Machine-specific hardware belongs only in that machine's generated `hardware-configuration.nix`.

## In a personal fork

1. Boot the NixISO installer on the target machine.
2. Partition and mount the disks according to the NixOS manual.
3. Generate that machine's hardware configuration with `nixos-generate-config --root /mnt`.
4. Put the generated `hardware-configuration.nix` in the matching host directory.
5. Set that machine's bootloader, file systems, host name, and `system.stateVersion`.
6. Define the personal user account in the host or a personal module. Set its shell to Fish (or rely on `users.defaultUserShell`).
7. Import `home/common.nix` for that user through Home Manager and set that user's `home.username`, `home.homeDirectory`, and `home.stateVersion`.

The host modules are templates; they deliberately do not contain guessed partition, firmware, bootloader, or device details. They are not complete installable host outputs until the actual hardware configuration and machine-specific boot settings have been added in the fork.

A two-machine fork should keep the shared modules identical and keep the per-device differences limited to the two host directories and generated hardware configurations.
