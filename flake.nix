{
  description = "Josues-MacBook-Pro nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, flake-utils }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .
    darwinConfigurations."Josues-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        ./modules/system.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "josue";
          };
        }
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.josue = import ./home.nix;
          };
        }
      ];
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    };
    darwinPackages = self.darwinConfigurations."Josues-MacBook-Pro".pkgs;
  };
}
