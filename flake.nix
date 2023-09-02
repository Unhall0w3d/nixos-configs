{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixops.url = "github:nixos/nixops";
  };

  outputs = { self, nixpkgs, ... } @ args: {
    nixosConfigurations.kennethp = nixpkgs.lib.nixosSystem {
      inherit (self.packages.x86_64-linux) pkgs;
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };

    packages = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in
      {
        pkgs = pkgs // removeAttrs self.packages.${system} [ "profiles" "pkgs" ];

        profiles = import ./profile.nix {
          inherit (self.packages.${system}) pkgs;
        };
      }
    );
  };
}
