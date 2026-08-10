# nix-darwin system configuration
# macOS system settings, nix settings, user configuration

{ pkgs, ... }:

{
  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Enable Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # User shell
  users.users.scc.shell = /usr/local/bin/nushell;

  # ---- macOS System Defaults ----
  system.defaults = {
    # Global domain settings
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleSpacesSwitchOnActivate = false;
      AppleEnableSwipeNavigateWithScrolls = false;
      AppleWindowTabbingMode = "manual";
      AppleKeyboardUIMode = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      _HIHideMenuBar = false; # menu bar always visible
    };

    # Finder
    finder = {
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = false;
      _FXShowPosixPathInTitle = true;
      FXPreferredViewStyle = "Nlsv"; # list view
      QuitMenuItem = true;
    };

    # Dock
    dock = {
      autohide = true;
      show-recents = false;
      mineffect = "scale";
      "minimize-to-application" = true;
      launchanim = false;
      magnification = false;
      orientation = "bottom";
      mru-spaces = false;
    };

    # Spaces — displays have separate spaces = false
    # (matches aerospace config requirement)
    spaces."spans-displays" = false;

    # Trackpad
    trackpad = {
      Clicking = false; # tap to click = off (physical click)
      TrackpadRightClick = true;
    };

    # Screenshots
    screencapture = {
      location = "/private/tmp";
    };
  };

  # System packages (nix-darwin managed, available system-wide)
  environment.systemPackages = with pkgs; [
    # Core tools that should be available even outside HM
  ];
}
