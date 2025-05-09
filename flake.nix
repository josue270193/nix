{
  description = "Josue nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      nix.extraOptions = ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
	  pkgs.mkalias
	  pkgs.neovim
 	  pkgs.tmux
	  pkgs.vscode
	  pkgs.grpcurl
	  pkgs.ghostty

	  pkgs.oh-my-zsh
    	  pkgs.zsh
    	  pkgs.zsh-completions
    	  pkgs.zsh-powerlevel10k
    	  pkgs.zsh-syntax-highlighting
    	  pkgs.zsh-history-substring-search
        ];

      homebrew = {
	enable = true;
	casks = [
	  "the-unarchiver"
        ];
      };
            
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
      '';

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
 
      # Default editor
      environment.variables.EDITOR = "nvim";

      # zsh and oh-my-zsh
      programs.zsh = {
        enable = true;
	theme = "agnoster";
    	ohMyZsh = {
          enable = true;
          plugins = [ "git" "python" "man" "zsh-syntax-highlighting" "zsh-history-substring-search" ];
    	};    
      };
      users.users.USER.shell = pkgs.zsh;

    };

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."macos" = nix-darwin.lib.darwinSystem {
      modules = [ 
	configuration
	nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "josue";

            # Automatically migrate existing Homebrew installations
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
