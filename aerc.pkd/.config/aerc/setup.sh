#!/bin/bash
pass-cli inject \
  --in-file accounts.template \
  --out-file accounts.conf \
  --file-mode 0600 \
  --force

# TODO: add keychain setup
