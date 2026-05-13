{ pkgs, config, lib, ... }:

# Core nix-darwin system configuration — packages, user, shell, and the
# /Applications symlink workaround. GUI/cask installs live in
# ./homebrew.nix; macOS user preferences live in ./macos-defaults.nix.

{
  system.primaryUser = "josue";
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    mkalias
    neovim
    tmux
    grpcurl
    curl
    gnupg
    awscli2
    cargo
    rustc
  ];

  # Spotlight-indexable aliases for Nix-installed .app bundles.
  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = [ "/Applications" ];
    };
  in lib.mkForce ''
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

  nix.settings.experimental-features = "nix-command flakes";

  system.configurationRevision = null; # This is overridden in the flake

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  environment.variables.EDITOR = "nvim";

  programs.zsh.enable = true;

  users.users.josue = {
    shell = pkgs.zsh;
    name = "josue";
    home = "/Users/josue";
  };
}
