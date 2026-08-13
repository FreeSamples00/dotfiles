# Cachix Binary Cache Setup

Defer this until after nix-darwin is fully working. This is an optimization for faster builds on new machines.

## Why

- First `darwin-rebuild switch` on a new machine: 20-40 min (compiles from source)
- With Cachix: 2-5 min (downloads prebuilt binaries)
- No security risk — cryptographic signing, you trust your own key, not Cachix

## Account Setup

1. Create account at https://cachix.org
2. Create a cache (e.g. `scc-dotfiles`)
3. Save the auth token and public key from the dashboard

## Configure nix-darwin

Add to `nix/darwin/system.nix` in the `nix.settings` block:

```nix
nix.settings = {
  experimental-features = [ "nix-command" "flakes" ];
  auto-optimise-store = true;
  extra-substituters = [ "https://scc-dotfiles.cachix.org" ];
  extra-trusted-public-keys = [ "scc-dotfiles.cachix.org-1:<PUBLIC_KEY>" ];
};
```

## Install Cachix Tool

```bash
nix profile install nixpkgs#cachix
cachix authtoken <AUTH_TOKEN>
```

## Push Binaries After Build

After a successful `darwin-rebuild switch`, push the built paths to your cache:

```bash
# Push the entire system closure
nix build .#darwinConfigurations.scc-mac.system
cachix push scc-dotfiles $(nix-store -q --references $(readlink result))

# Or push a specific path
cachix push scc-dotfiles /nix/store/xxxxx-...
```

## New Machine Setup

No extra steps needed if `nix/darwin/system.nix` has the substituter config.
The first `darwin-rebuild switch` will automatically pull from your Cachix cache.

## Security Notes

- Binaries are cryptographically signed with your private key
- Nix verifies signatures before using any cached binary
- If verification fails, Nix falls back to building from source
- Your cache requires auth token to push (only you can push)
- Public key is embedded in config (no auth needed to pull)
- More secure than Homebrew (no signature verification) or Docker Hub (no verification by default)
