{ config, pkgs, lib, pkgs-unstable, ... }:

# Home-manager configuration for user `josue`.
#
# Runtime version management is delegated entirely to mise — one tool for
# python, node, java, and anything else added later. The previous
# pyenv/jenv/nvm trio (and the ~80 lines of activation shell that glued
# them together) is gone.

{
  home.username = "josue";
  home.homeDirectory = "/Users/josue";
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    curl
    wget
    gawk
    coreutils
    gnutar
    xz
    htop
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll  = "ls -la";
      gs  = "git status";
      gp  = "git pull";
      gco = "git checkout";
      k   = "kubectl";
      d   = "docker";
    };

    initContent = ''
      # mise activates itself (handled by programs.mise.enableZshIntegration)
      # so PATH for installed runtimes is set up automatically.

      # Use starship prompt last
      eval "$(starship init zsh)"
    '';
  };

  # Polyglot runtime version manager. Replaces pyenv + jenv + nvm.
  # Global pins live below; per-project pins go in `.mise.toml` /
  # `.tool-versions` checked into each repo.
  programs.mise = {
    enable = true;
    package = pkgs-unstable.mise; # pinned to unstable for latest bug fixes
    enableZshIntegration = true;

    globalConfig = {
      tools = {
        python = "latest";
        node = "lts";
        java = "21";
      };
      settings = {
        # auto-install missing versions when entering a project dir
        idiomatic_version_file_enable_tools = [ "python" "node" "java" ];
      };
    };
  };

  programs.starship.enable = true;
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.direnv.enable = true;     # per-project env via .envrc

  programs.git = {
    enable = true;
    aliases = {
      s    = "status";
      p    = "pull";
      co   = "checkout";
      br   = "branch";
      ci   = "commit";
      st   = "status -sb";
      last = "log -1 HEAD";
      lg   = "log --oneline --graph --decorate --all";
      unstage = "reset HEAD --";
    };
  };

  # Copy ghostty configs
  home.file = {
    "Library/Application Support/com.mitchellh.ghostty/config".source = ./ghostty/config;
    "Library/Application Support/com.mitchellh.ghostty/inside-the-matrix.glsl".source = ./ghostty/inside-the-matrix.glsl;
  };

  home.stateVersion = "25.11"; # match your system or nixpkgs version
}
