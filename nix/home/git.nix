# Home Manager module: Git configuration
# Translates git.pkd/dot-gitconfig into programs.git options
# Delta colors injected from nix/colors.nix (derived.*, accent.normal.*, structural.*)

{ config, lib, pkgs, colors, ... }:

let
  h = colors.withHash;
  d = colors.derived;
  a = colors.accent.normal;
  s = colors.structural;
in {
  programs.git = {
    enable = true;
    package = pkgs.git;

    settings = {
      user = {
        name = "Spencer Christensen";
        email = "134820811+FreeSamples00@users.noreply.github.com";
      };

      init.defaultBranch = "main";

      core = {
        excludesfile = "~/.gitignore";
        pager = "delta -s";
        editor = "nvim";
      };

      pull.rebase = false;

      color = {
        ui = "auto";
        status = "auto";
        diff = "auto";
        branch = "auto";
      };

      merge = {
        tool = "nvim";
        conflictStyle = "zdiff3";
      };

      mergetool = {
        keepBackup = false;
        prompt = false;
      };

      "mergetool \"nvim\"" = {
        cmd = ''MERGED="$MERGED" nvim -d -c "wincmd l" -c "norm! ]c" "$LOCAL" "$MERGED" "$REMOTE"'';
      };

      delta = {
        line-numbers = true;
        navigate = true;
        hyperlinks = true;
        paging = "auto";
        dark = true;
        word-diff = true;
        true-color = "always";
        width = "variable";
        syntax-theme = "Catppuccin Mocha";

        minus-style = "syntax ${h d.diff-minus}";
        minus-emph-style = "syntax ${h d.diff-minus-emph}";
        plus-style = "syntax ${h d.diff-plus}";
        plus-emph-style = "syntax ${h d.diff-plus-emph}";
        zero-style = "syntax";

        line-numbers-minus-style = h a.red;
        line-numbers-plus-style = h a.green;
        line-numbers-zero-style = h s.border;

        commit-style = "${h a.orange} bold";
        commit-decoration-style = "${h s.surface} ol";
        file-style = h d.diff-file;
        file-decoration-style = "";
        hunk-header-style = "${h d.diff-hunk} bold";
        hunk-header-decoration-style = "";
        hunk-header-file-style = h d.diff-file;
        hunk-header-line-number-style = h d.diff-hunk;
        inline-hint-style = h d.diff-hint;

        blame-palette = "${d.diff-blame-1} ${d.diff-blame-2} ${d.diff-blame-3} ${d.diff-blame-4} ${d.diff-blame-5}";
        blame-code-style = "syntax";
        blame-separator-style = h d.diff-separator;
        blame-separator-format = "{n:^4} │";
      };
    };
  };

  # Deploy .gitignore (not managed by programs.git.ignores since it's a global file)
  home.file.".gitignore".source = ../../git.pkd/dot-gitignore;

  # Install delta
  home.packages = [ pkgs.delta ];
}
