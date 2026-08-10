# nix-darwin launchd services
# Manages sketchybar, aerospace, jankyborders, and obsidian as launchd agents
{
  config,
  pkgs,
  ...
}: let
  # PATH for service processes — includes Nix profile and Homebrew
  servicePath = "/Users/scc/.nix-profile/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin";
in {
  launchd.user.agents = {
    # Sketchybar — custom macOS status bar
    sketchybar = {
      serviceConfig = {
        Label = "io.github.felixkratz.sketchybar";
        ProgramArguments = ["/opt/homebrew/bin/sketchybar"];
        RunAtLoad = true;
        KeepAlive = true;
        EnvironmentVariables = {
          PATH = servicePath;
          HOME = "/Users/scc";
        };
        StandardOutPath = "/Users/scc/Library/Logs/sketchybar.log";
        StandardErrorPath = "/Users/scc/Library/Logs/sketchybar.err";
      };
    };

    # AeroSpace — tiling window manager
    aerospace = {
      serviceConfig = {
        Label = "com.github.nikitabobko.aerospace";
        ProgramArguments = ["/Applications/AeroSpace.app/Contents/MacOS/aerospace"];
        RunAtLoad = true;
        KeepAlive = true;
        EnvironmentVariables = {
          PATH = servicePath;
          HOME = "/Users/scc";
        };
        StandardOutPath = "/Users/scc/Library/Logs/aerospace.log";
        StandardErrorPath = "/Users/scc/Library/Logs/aerospace.err";
      };
    };

    # Jankyborders — window border system
    jankyborders = {
      serviceConfig = {
        Label = "io.github.felixkratz.borders";
        ProgramArguments = ["/opt/homebrew/bin/borders"];
        RunAtLoad = true;
        KeepAlive = true;
        EnvironmentVariables = {
          PATH = servicePath;
          HOME = "/Users/scc";
        };
        StandardOutPath = "/Users/scc/Library/Logs/borders.log";
        StandardErrorPath = "/Users/scc/Library/Logs/borders.err";
      };
    };

    # Obsidian — note-taking app, auto-launch at login
    obsidian = {
      serviceConfig = {
        Label = "md.obsidian";
        ProgramArguments = ["/Applications/Obsidian.app/Contents/MacOS/Obsidian"];
        RunAtLoad = true;
        KeepAlive = false; # don't restart if user quits
        EnvironmentVariables = {
          PATH = servicePath;
          HOME = "/Users/scc";
        };
      };
    };
  };
}
