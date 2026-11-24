# Host configurations

The desktop and laptop both import the same AMD system module:

- `modules/nixos/amd-common.nix`
- `home/common.nix` for the personal account on each installed system

Keep common operating-system behavior and common applications in those shared files. Machine-specific hardware belongs only in that machine's generated `hardware-configuration.nix`.

## In a personal fork

1. Boot the NixISO installer on the target machine.
2. Partition and mount its disks according to the NixOS manual.
3. Generate that machine's hardware configuration with `nixos-generate-config --root /mnt`.
4. Put the generated `hardware-configuration.nix` in the matching host directory.
5. Set that machine's bootloader, file systems, and `system.stateVersion`.
6. Define your personal account in a host or personal module.
7. Import `home/common.nix` for that account through Home Manager and set `home.username`, `home.homeDirectory`, and `home.stateVersion`.

The generic host modules are templates: they deliberately contain no guessed partition, firmware, bootloader, or device details. They are not complete installable host outputs until the actual hardware configuration and machine-specific boot settings are added in your fork.

## Example Home Manager user declaration

Add the following to the host-specific module in your fork, replacing `YOUR_USERNAME` and the state-version placeholder with your actual values:

```nix
{ ... }:

{
  users.users."YOUR_USERNAME" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  home-manager.users."YOUR_USERNAME" = {
    imports = [
      ../../home/common.nix
    ];

    home.username = "YOUR_USERNAME";
    home.homeDirectory = "/home/YOUR_USERNAME";
    home.stateVersion = "SET_THIS_FOR_YOUR_USER";
  };
}
```

The Home Manager NixOS module must be included in the fork's flake for each host. The existing flake input and `home-manager.inputs.nixpkgs.follows = "nixpkgs"` setting are already provided.

A two-machine fork should keep `modules/nixos/amd-common.nix` and `home/common.nix` identical. Keep per-device differences in the two host directories and generated hardware configurations, and keep personal customizations in separate modules.
