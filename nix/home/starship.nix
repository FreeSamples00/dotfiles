# Home Manager module: Starship prompt
# Translates starship.pkd/.config/starship.toml into programs.starship settings
# Palette colors injected from nix/colors.nix (accent.bright.*, structural.*, derived.*)
{
  config,
  lib,
  pkgs,
  colors,
  ...
}: let
  h = colors.withHash;
  b = colors.accent.bright;
  s = colors.structural;
  d = colors.derived;
in {
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      add_newline = true;
      scan_timeout = 10;
      palette = "catppuccin_mocha";

      format = " $directory$git_branch$git_status$git_state$nix_shell$fill $status$hostname$cmd_duration$sudo$memory_usage$time $line_break  $character";

      fill = {
        disabled = false;
        style = "spacer_color";
        symbol = "─";
      };

      character = {
        disabled = false;
        success_symbol = "[➔](bold green)";
        error_symbol = "[➔](bold red)";
      };

      directory = {
        disabled = false;
        truncation_length = 1;
        truncation_symbol = "";
        style = "dir_color";
        format = "[ $path]($style) ";
      };

      git_branch = {
        disabled = false;
        style = "git_orange";
        symbol = "󰊢";
        format = "[─](spacer_color) [$symbol $branch]($style) ";
      };

      git_status = {
        disabled = false;
        ahead = "↑$\{count\} ";
        behind = "↓$\{count\} ";
        diverged = "↓$\{ahead_count\}↑$\{behind_count\} ";
        modified = "!$\{count\} ";
        untracked = "?$\{count\} ";
        stashed = "*$\{count\} ";
        conflicted = "~$\{count\} ";
        staged = "+$\{count\} ";
        deleted = "-$\{count\} ";
        format = "[$ahead_behind](git_ahead_behind)[$stashed](git_stashed)[$conflicted](git_conflicted)[$staged](git_staged)[$deleted](git_deleted)[$modified](git_modified)[$untracked](git_untracked)";
      };

      git_state = {
        disabled = false;
        style = "git_state_color";
        format = "[─](spacer_color) [󰚖 $state ($progress_current/$progress_total)]($style) ";
        rebase = "REBASE";
        merge = "MERGE";
        revert = "REVERT";
        cherry_pick = "CHERRY";
        bisect = "BISECT";
        am = "AM";
        am_or_rebase = "AM/REBASE";
      };

      cmd_duration = {
        disabled = false;
        style = "timer_color";
        format = "[󰔛 $duration]($style) [─](spacer_color) ";
      };

      time = {
        disabled = false;
        style = "clock_color";
        time_format = "%I:%M%P";
        format = "[󰔛 $time]($style)";
      };

      nix_shell = {
        disabled = false;
        symbol = "󱄅";
        style = "nix_color";
        pure_msg = "pure";
        impure_msg = "impure";
        unknown_msg = "dev";
        heuristic = true;
        format = "[─](spacer_color) [$symbol $name \\[$state\\]](nix_color) ";
      };

      memory_usage = {
        disabled = false;
        threshold = 70;
        symbol = "";
        style = "memory_color";
        format = "[$symbol $ram_pct]($style) [─](spacer_color) ";
      };

      status = {
        disabled = false;
        style = "red";
        symbol = "";
        recognize_signal_code = false;
        format = "[$symbol $status]($style) [─](spacer_color) ";
      };

      hostname = {
        disabled = false;
        ssh_only = true;
        trim_at = ".";
        style = "bold yellow";
        format = "[󰒋 $hostname]($style) [─](spacer_color) ";
      };

      sudo = {
        disabled = false;
        format = "[SUDO]($style) [─](spacer_color) ";
        style = "bold red";
      };

      palettes.catppuccin_mocha = {
        spacer_color = h s.surface;
        timer_color = h b.yellow;
        dir_color = h b.blue;
        clock_color = h b.azure;
        memory_color = h b.salmon;
        nix_color = h b.purple;

        git_orange = h d.git-branch;
        git_state_color = "#f5906a"; # hand-tuned, not in colorscheme
        git_modified = h b.yellow;
        git_untracked = h b.blue;
        git_ahead_behind = h b.green;
        git_staged = h b.green;
        git_unstaged = h b.blue;
        git_stashed = h b.purple;
        git_conflicted = h b.red;
        git_deleted = h b.red;
      };
    };
  };
}
