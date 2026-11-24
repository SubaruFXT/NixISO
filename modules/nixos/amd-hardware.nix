{ pkgs, ... }:

{
  # Use the newest kernel package set from the locked nixpkgs revision.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Basic AMD platform support: firmware, graphics and CPU microcode.
  hardware = {
    enableRedistributableFirmware = true;
    graphics.enable = true;
    cpu.amd.updateMicrocode = true;
  };
}
