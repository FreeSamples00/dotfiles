# Home Manager module: Lazygit config
# Translates lazygit.pkd/.config/lazygit/config.yml into programs.lazygit settings
# Theme colors injected from nix/colors.nix (accent.normal.*, structural.*)
{
  config,
  lib,
  pkgs,
  colors,
  ...
}: let
  h = colors.withHash;
  a = colors.accent.normal;
  s = colors.structural;
in {
  programs.lazygit = {
    enable = true;

    settings = {
      notARepository = "quit";
      disableStartupPopups = true;
      promptToReturnFromSubprocess = false;

      git = {
        autoFetch = false;
        disableForcePushing = true;
        diffRenderers = [
          {command = "delta --paging=never";}
        ];
      };

      os = {
        editPreset = "nvim";
        editAtLine = "nvim {{filename}} +{{line}}";
        openDirInEditor = "nvim {{filename}}";
      };

      gui = {
        expandFocusedSidePanel = true;
        tabWidth = 2;
        enlargedSideViewLocation = "left";
        sidePanelWidth = 0.25;
        expandedSidePanelWeight = 3;
        showRootItemInFileTree = false;
        fileTreeSortOrder = "foldersFirst";
        showBottomLine = false;
        showCommandLog = false;
        nerdFontsVersion = "3";
        showDivergenceFromBaseBranch = "arrowAndNumber";
        border = "rounded";
        statusPanelView = "allBranchesLog";

        spinner = {
          rate = 100;
          frames = [
            "⠋"
            "⠙"
            "⠹"
            "⠸"
            "⠼"
            "⠴"
            "⠦"
            "⠧"
            "⠇"
            "⠏"
          ];
        };

        theme = {
          activeBorderColor = [(h a.orange) "bold"];
          inactiveBorderColor = [(h s.fg-muted)];
          optionsTextColor = [(h a.blue)];
          selectedLineBgColor = [(h s.surface-sunken)];
          cherryPickedCommitBgColor = [(h s.surface)];
          cherryPickedCommitFgColor = [(h a.orange)];
          unstagedChangesColor = [(h a.red)];
          defaultFgColor = [(h s.fg)];
          searchingActiveBorderColor = [(h a.yellow)];
          inactiveViewSelectedLineBgColor = [(h s.surface-raised)];
          markedBaseCommitFgColor = [(h a.purple)];
          markedBaseCommitBgColor = [(h s.surface)];
        };

        branchColorPatterns = {
          "^(main|master)$" = h a.blue;
          "^develop$" = h a.teal;
          "^(feat|feature)/" = h a.green;
          "^fix/" = h a.orange;
          "^(chore|docs|refactor|test|ci)/" = h a.purple;
        };

        authorColors = {
          "*" = h a.lilac;
        };
      };
    };
  };
}
