_default:
    just --unsorted --list

# Setup account credentials
[group('setup')]
accounts:
    pass-cli inject \
    --in-file accounts.template \
    --out-file accounts.conf \
    --file-mode 0600 \
    --force

# TODO: add keychain setup
