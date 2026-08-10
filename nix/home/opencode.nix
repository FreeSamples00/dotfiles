# Home Manager module: Opencode
# Source-filter (exclude opencode.jsonc) + generated opencode.jsonc from Nix attrset
# Model variables from nix/shared/models.nix

{ config, lib, pkgs, models, ... }:

let
  m = models;
in {
  # Deploy entire opencode tree EXCEPT the generated jsonc
  xdg.configFile."opencode" = {
    source = lib.cleanSourceWith {
      src = ../../llm.pkd/.config/opencode;
      filter = path: _type:
        !(lib.hasSuffix "/opencode.jsonc" path);
    };
    recursive = true;
  };

  # Generated opencode.jsonc from Nix attrset
  xdg.configFile."opencode/opencode.jsonc".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    model = m.models.large;
    small_model = m.models.small;
    default_agent = "plan";
    share = "disabled";
    plugin = [
      "@tarquinen/opencode-smart-title"
      "@mohak34/opencode-notifier@latest"
    ];
    provider = {
      synthetic = {
        npm = m.provider.npm;
        name = m.provider.name;
        options.baseURL = m.provider.baseURL;
        models = builtins.mapAttrs (id: spec:
          spec
        ) m.specs;
      };
    };
    permission = {
      "*" = "deny";
      skill = "allow";
      bash = {
        "*" = "ask";
        "nu *" = "allow";
        "make *" = "allow";
        "pwd *" = "allow";
        "ls *" = "allow";
        "find *" = "allow";
        "cat *" = "allow";
        "tail *" = "allow";
        "head *" = "allow";
        "grep *" = "allow";
        "rg *" = "allow";
        "file *" = "allow";
        "stat *" = "allow";
        "wc *" = "allow";
        "tree *" = "allow";
        "which *" = "allow";
        "brew list" = "allow";
        "* --version" = "allow";
        "* --help" = "allow";
        "just *" = "allow";
        "pdftotext *" = "allow";
        "pdftoppm *" = "allow";
        "pdfinfo *" = "allow";
        "tesseract *" = "allow";
        "git *" = "deny";
        "git status" = "allow";
        "git diff *" = "allow";
        "git log *" = "allow";
        "git show *" = "allow";
        "git rev-parse *" = "allow";
        "rm -rf *" = "deny";
        "pass-cli *" = "deny";
      };
    };
    agent = {
      plan = {
        mode = "primary";
        color = "primary";
        model = m.models.${m.agents.plan.model};
        reasoningEffort = m.agents.plan.reasoningEffort;
        permission = {
          read = { "*" = "allow"; "*.priv" = "deny"; };
          grep = "allow";
          glob = "allow";
          list = "allow";
          lsp = "allow";
          todowrite = "allow";
          webfetch = "allow";
          codesearch = "allow";
          question = "allow";
          doom_loop = "ask";
          external_directory = { "*" = "ask"; "/tmp" = "allow"; "~/.local/share/nvim" = "allow"; };
          task = { "*" = "deny"; explorer = "allow"; librarian = "allow"; vision = "allow"; oracle = "ask"; };
        };
      };
      build = {
        mode = "primary";
        color = "secondary";
        model = m.models.${m.agents.build.model};
        reasoningEffort = m.agents.build.reasoningEffort;
        permission = {
          read = { "*" = "allow"; "*.priv" = "deny"; };
          edit = "allow";
          write = "allow";
          patch = "ask";
          grep = "allow";
          glob = "allow";
          list = "allow";
          lsp = "allow";
          todowrite = "allow";
          webfetch = "allow";
          codesearch = "allow";
          question = "allow";
          doom_loop = "ask";
          external_directory = { "*" = "ask"; "/tmp" = "allow"; };
          task = { "*" = "allow"; oracle = "ask"; };
        };
      };
      explorer = {
        mode = "subagent";
        model = m.models.${m.agents.explorer.model};
        steps = 12;
        temperature = 0.2;
        reasoningEffort = m.agents.explorer.reasoningEffort;
        hidden = false;
        permission = {
          bash = "deny";
          read = { "*" = "allow"; "*.priv" = "deny"; };
          grep = "allow";
          glob = "allow";
          list = "allow";
        };
      };
      librarian = {
        mode = "subagent";
        model = m.models.${m.agents.librarian.model};
        steps = 10;
        temperature = 0.2;
        reasoningEffort = m.agents.librarian.reasoningEffort;
        hidden = false;
        permission = {
          bash = "deny";
          webfetch = "allow";
          websearch = "allow";
        };
      };
      documenter = {
        mode = "subagent";
        model = m.models.${m.agents.documenter.model};
        steps = 10;
        temperature = 0.2;
        reasoningEffort = m.agents.documenter.reasoningEffort;
        hidden = true;
        permission = {
          bash = "deny";
          read = { "*" = "allow"; "*.priv" = "deny"; };
          edit = "allow";
          write = "allow";
          grep = "allow";
          glob = "allow";
          list = "allow";
        };
      };
      fixer = {
        mode = "subagent";
        model = m.models.${m.agents.fixer.model};
        steps = 25;
        temperature = 0.2;
        reasoningEffort = m.agents.fixer.reasoningEffort;
        hidden = true;
        permission = {
          bash = {
            "*" = "deny";
            "just *" = "allow";
            "make *" = "allow";
            "npm run *" = "allow";
            "bun test *" = "allow";
            "bun run *" = "allow";
            "pytest *" = "allow";
            "cargo test *" = "allow";
            "cargo check *" = "allow";
            "go test *" = "allow";
            "go vet *" = "allow";
            "git diff *" = "allow";
            "git status" = "allow";
          };
          read = { "*" = "allow"; "*.priv" = "deny"; };
          edit = "allow";
          write = "allow";
          grep = "allow";
          glob = "allow";
          list = "allow";
        };
      };
      compaction = {
        model = m.models.${m.agents.compaction.model};
        reasoningEffort = m.agents.compaction.reasoningEffort;
        hidden = true;
        permission = { "*" = "deny"; };
      };
      vision = {
        mode = "subagent";
        model = m.models.${m.agents.vision.model};
        steps = 5;
        temperature = 0.2;
        reasoningEffort = m.agents.vision.reasoningEffort;
        hidden = false;
        permission = {
          bash = { "*" = "deny"; "ls *" = "allow"; "file *" = "allow"; };
          read = { "*" = "allow"; };
          glob = "allow";
          list = "allow";
          external_directory = { "/tmp" = "allow"; };
        };
      };
      oracle = {
        mode = "subagent";
        model = m.models.${m.agents.oracle.model};
        steps = 12;
        temperature = 0.2;
        reasoningEffort = m.agents.oracle.reasoningEffort;
        hidden = false;
        permission = {
          bash = "deny";
          read = { "*" = "allow"; "*.priv" = "deny"; };
          grep = "allow";
          glob = "allow";
          list = "allow";
          lsp = "allow";
          task = { "*" = "deny"; explorer = "allow"; librarian = "allow"; vision = "allow"; };
          external_directory = { "*" = "ask"; "/tmp" = "allow"; };
        };
      };
    };
  };
}
