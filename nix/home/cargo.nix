# Home Manager module: Cargo config
# Forces Rust to use Apple's Clang (/usr/bin/cc) as the linker instead of the
# Nix GCC wrapper, which can't find -liconv from the macOS SDK.
# Required for Mason to compile Rust-based tools (nil, alejandra).
{...}: {
  programs.cargo = {
    enable = true;
    package = null; # cargo provided by rustup in profiles/default.nix
    settings = {
      target.aarch64-apple-darwin = {
        linker = "/usr/bin/cc";
      };
    };
  };
}
