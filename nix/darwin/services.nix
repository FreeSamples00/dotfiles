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
    # NOTE: Sketchybar (and the getfocus plugin for focus mode detection) requires
    # Full Disk Access to read ~/Library/DoNotDisturb/DB/Assertions.json.
    # Grant via System Settings > Privacy & Security > Full Disk Access > sketchybar.
    # Without it, getfocus exits 1 and the focus notifier shows a warning triangle.
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

    # Obsidian — note-taking app with background sync
    # Uses a wrapper that checks if Obsidian is already running before launching.
    # This prevents the window from popping up during darwin-rebuild switch.
    # KeepAlive.SuccessfulExit = false: restart on crash (non-zero exit), but not on clean exit (user quit).
    obsidian = {
      serviceConfig = {
        Label = "md.obsidian";
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "pgrep -x Obsidian > /dev/null 2>&1 || exec /Applications/Obsidian.app/Contents/MacOS/Obsidian"
        ];
        RunAtLoad = true;
        KeepAlive.SuccessfulExit = false;
        EnvironmentVariables = {
          PATH = servicePath;
          HOME = homeDirectory;
        };
      };
    };
  };
}
