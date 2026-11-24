{
  description = "NixOS live installer and shared system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/iso
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/laptop
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/desktop
        ];
      };
    };

    packages.x86_64-linux.iso =
      self.nixosConfigurations.iso.config.system.build.isoImage;
  };
}
