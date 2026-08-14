# nix-darwin launchd services
# Manages sketchybar, aerospace, jankyborders, and obsidian as launchd agents

{ config, pkgs, username, homeDirectory, ... }:

let
  # PATH for service processes — includes both Nix profile paths and Homebrew
  # ~/.local/state/nix/profiles/home-manager/home-path/bin: nix-darwin embedded HM
  # ~/.nix-profile/bin: standalone HM
  servicePath = "${homeDirectory}/.local/state/nix/profiles/home-manager/home-path/bin:${homeDirectory}/.nix-profile/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin";
in {
  launchd.user.agents = {
    # Sketchybar — custom macOS status bar
    sketchybar = {
      serviceConfig = {
        Label = "io.github.felixkratz.sketchybar";
        ProgramArguments = [ "/opt/homebrew/bin/sketchybar" ];
        RunAtLoad = true;
        KeepAlive = true;
        EnvironmentVariables = {
          PATH = servicePath;
          HOME = homeDirectory;
        };
        StandardOutPath = "${homeDirectory}/Library/Logs/sketchybar.log";
        StandardErrorPath = "${homeDirectory}/Library/Logs/sketchybar.err";
      };
    };

    # AeroSpace — tiling window manager
    aerospace = {
      serviceConfig = {
        Label = "com.github.nikitabobko.aerospace";
        ProgramArguments = [ "/Applications/AeroSpace.app/Contents/MacOS/aerospace" ];
        RunAtLoad = true;
        KeepAlive = true;
        EnvironmentVariables = {
          PATH = servicePath;
          HOME = homeDirectory;
        };
        StandardOutPath = "${homeDirectory}/Library/Logs/aerospace.log";
        StandardErrorPath = "${homeDirectory}/Library/Logs/aerospace.err";
      };
    };

    # Jankyborders — window border system
    jankyborders = {
      serviceConfig = {
        Label = "io.github.felixkratz.borders";
        ProgramArguments = [ "/opt/homebrew/bin/borders" ];
        RunAtLoad = true;
        KeepAlive = true;
        EnvironmentVariables = {
          PATH = servicePath;
          HOME = homeDirectory;
        };
        StandardOutPath = "${homeDirectory}/Library/Logs/borders.log";
        StandardErrorPath = "${homeDirectory}/Library/Logs/borders.err";
      };
    };

    # Obsidian — note-taking app, auto-launch at login
    obsidian = {
      serviceConfig = {
        Label = "md.obsidian";
        ProgramArguments = [ "/Applications/Obsidian.app/Contents/MacOS/Obsidian" ];
        RunAtLoad = true;
        KeepAlive = false; # don't restart if user quits
        EnvironmentVariables = {
          PATH = servicePath;
          HOME = homeDirectory;
        };
      };
    };
  };
}
