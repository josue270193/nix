{ ... }:

# macOS system defaults — the file you'll thank yourself for every time you
# reset a machine. All settings are applied via `defaults write` under the
# hood by nix-darwin, so a `darwin-rebuild switch` is enough to restore them.
#
# After changing this file you may need to log out (or run `killall Dock
# Finder SystemUIServer`) for some changes to take effect.

{
  system.defaults = {
    # Dock
    dock.autohide = true;
    dock.autohide-delay = 0.0;
    dock.autohide-time-modifier = 0.5;
    dock.mru-spaces = false;          # don't rearrange Spaces by most-recent-use
    dock.show-recents = false;        # hide recent apps section
    dock.tilesize = 48;
    dock.minimize-to-application = true;

    # Finder
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";     # column view
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;
    finder.FXEnableExtensionChangeWarning = false;
    finder._FXShowPosixPathInTitle = true;
    finder._FXSortFoldersFirst = true;
    finder.FXDefaultSearchScope = "SCcf";     # search current folder by default

    # Trackpad — tap-to-click
    trackpad.Clicking = true;
    trackpad.TrackpadRightClick = true;
    trackpad.TrackpadThreeFingerDrag = true;

    # Keyboard / NSGlobalDomain — fast key repeat + sane defaults
    NSGlobalDomain.ApplePressAndHoldEnabled = false;   # disable the accent-popup, enables key repeat in editors
    NSGlobalDomain.KeyRepeat = 2;                       # 2 = ~30ms repeat (very fast)
    NSGlobalDomain.InitialKeyRepeat = 15;               # ~225ms before repeat starts
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllFiles = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
    NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;

    # Screenshots
    screencapture.location = "~/Pictures/screenshots";
    screencapture.type = "png";
    screencapture.disable-shadow = true;

    # Login window
    loginwindow.LoginwindowText = "josue270193@gmail.com";
    loginwindow.GuestEnabled = false;

    # Screensaver / lock
    screensaver.askForPassword = true;
    screensaver.askForPasswordDelay = 10;

    # Menu bar
    menuExtraClock.Show24Hour = true;
    menuExtraClock.ShowSeconds = false;
    menuExtraClock.ShowDate = 1;       # always show date

    # Spaces — keep displays independent
    spaces.spans-displays = false;
  };
}
