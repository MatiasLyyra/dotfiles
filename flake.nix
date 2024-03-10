{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:

  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      homer = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { networking.hostName = "homer"; }
          ./hosts/homer/configuration.nix
          home-manager.nixosModules.home-manager
          {
              home-manager = {
                  useUserPackages = true;
                  useGlobalPkgs = true;
                  extraSpecialArgs = { inherit inputs; inherit pkgs; };
                  users.malyy = ./hosts/homer/malyy.nix;
              };
          }
        ];
        specialArgs = { inherit inputs; inherit pkgs; inherit lib; };
      };
    };
  };
}
