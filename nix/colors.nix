# Personal color palette derived from Catppuccin Mocha.
# See docs/colorscheme.md for full reference.
rec {
  # Active tier: "dimmed" | "normal" | "bright"
  tier = "normal";

  accent = {
    dimmed = {
      coral = "f5e0dc";
      salmon = "f2cdcd";
      pink = "f5c2e7";
      purple = "cba6f7";
      red = "f38ba8";
      red-soft = "eba0ac";
      orange = "fab387";
      yellow = "f9e2af";
      green = "a6e3a1";
      teal = "94e2d5";
      cyan = "89dceb";
      azure = "74c7ec";
      blue = "89b4fa";
      lilac = "b4befe";
    };
    normal = {
      coral = "f3b8b0";
      salmon = "f0aaaa";
      pink = "ee9dd4";
      purple = "c490f0";
      red = "ee668c";
      red-soft = "e67c92";
      orange = "f59a64";
      yellow = "f0d57c";
      green = "8ae28e";
      teal = "6addca";
      cyan = "6cd2ea";
      azure = "67c0ea";
      blue = "7aacf9";
      lilac = "a29ffb";
    };
    bright = {
      coral = "f09898";
      salmon = "ee8888";
      pink = "e878c0";
      purple = "b080f0";
      red = "e84070";
      red-soft = "e05878";
      orange = "f08040";
      yellow = "e8c84a";
      green = "6de07a";
      teal = "40d8c0";
      cyan = "50c8e8";
      azure = "5ab8e8";
      blue = "6aa4f8";
      lilac = "9080f8";
    };
  };

  structural = {
    fg = "cdd6f4";
    fg-secondary = "bac2de";
    fg-muted = "a6adc8";
    fg-faint = "9399b2";
    border = "7f849c";
    border-muted = "6c7086";
    surface-raised = "585b70";
    surface = "45475a";
    surface-sunken = "313244";
  };

  background = {
    catppuccin = {
      base = "1e1e2e";
      mantle = "181825";
      crust = "11111b";
    };
    override = {
      base = "1E1E1E";
      mantle = "141414";
      crust = "0A0A0A";
    };
  };

  derived = {
    cursor = "CBD6F7"; # Ghostty terminal cursor
    git-branch = "f06040"; # Starship git branch indicator
    diff-file = "7aacf9"; # Delta file path header
    diff-hunk = "f0d57c"; # Delta hunk header
    diff-hint = "9399b2"; # Delta inline hints
    diff-separator = "7f849c"; # Delta blame separator
    diff-minus = "660000"; # Delta deletion bg
    diff-minus-emph = "8b3030"; # Delta deletion emphasis bg
    diff-plus = "0e2e1e"; # Delta addition bg
    diff-plus-emph = "1a4a2a"; # Delta addition emphasis bg
    diff-blame-1 = "3d3d4d"; # Delta blame gradient (lightest)
    diff-blame-2 = "383846";
    diff-blame-3 = "34343f";
    diff-blame-4 = "303038";
    diff-blame-5 = "2c2c31"; # Delta blame gradient (darkest)
    focus-dnd = "6d7cff"; # Focus mode: DND
    focus-sleep = "14b6a4"; # Focus mode: Sleep
    focus-reduce = "db34f2"; # Focus mode: Reduce Interruptions
  };

  # Format helpers
  withHash = v: "#${v}";
  with0x = v: "0xff${v}";

  # Convenience: get accent colors for current tier (with # prefix)
  # Usage: current.red -> "#ee668c" when tier = "normal"
  current =
    builtins.mapAttrs
    (_name: value: withHash value)
    accent.${tier};
}
