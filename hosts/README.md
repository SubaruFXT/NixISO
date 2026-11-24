# Host configurations

The desktop and laptop entry-point modules intentionally import the same shared AMD system module. Keep common operating-system behavior in `modules/nixos/amd-common.nix` so both machines use the same configuration.

Each machine has its own `hardware-configuration.nix`, generated on that machine. Do not copy one machine's hardware configuration to the other. Hardware configuration records device-specific storage, initrd, and kernel-module details.

The host entry points are templates, not complete installable host outputs yet. In your fork, add the generated hardware files and choose the correct bootloader, filesystem layout, hostname, `system.stateVersion`, and user account for your machines. Keep those personal choices out of the shared AMD module when they can be shared through a common module.

The public base flake currently builds only the live ISO. The installed desktop and laptop outputs should be added in a fork after their actual hardware and boot configuration has been supplied.
