{ ... }:

# Homebrew-managed GUI apps and CLI tools that aren't available (or are
# painful to use) through nixpkgs on darwin. Everything here is installed
# declaratively via nix-homebrew + nix-darwin's `homebrew` module.
#
# Note: the `nix-homebrew` flake input is enabled in flake.nix — this module
# only declares *what* to install, not how to bootstrap homebrew itself.

{
  homebrew = {
    enable = true;

    # Reconcile on every switch — uninstall things that aren't declared here.
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";   # remove unmanaged casks/brews/taps
      upgrade = true;
    };

    # CLI tools from homebrew. Prefer nixpkgs first; only land here when
    # there's a real reason (binary cask, signed app, or nix-broken package).
    # (mise lives in home.nix via programs.mise — nixpkgs has it.)
    brews = [
      "mas"      # Mac App Store CLI — required to install masApps below
    ];

    # GUI apps installed as macOS .app bundles via homebrew cask.
    casks = [
      # Utilities
      "the-unarchiver"
      "macs-fan-control"
      "openvpn-connect"

      # Browsers
      "google-chrome"
      "zen"

      # Terminal / dev tools
      "ghostty"
      "bruno"                # API client (Postman alternative)
      "orbstack"             # Docker Desktop + Linux VMs replacement (provides `docker` CLI)
      "jetbrains-toolbox"
      "visual-studio-code"

      # Productivity / notes
      "obsidian"

      # Media
      "spotify"
      "vlc"

      # Communication
      "slack"
    ];

    # Mac App Store apps — installed via `mas` (signed-in Apple ID required).
    # IDs come from `mas search "<name>"`; verify on a fresh machine if any of
    # these versions get superseded by separately-listed App Store entries.
    masApps = {
      "Microsoft Word"       = 462054704;
      "Microsoft Excel"      = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "WhatsApp"             = 310633997;
    };
  };
}
