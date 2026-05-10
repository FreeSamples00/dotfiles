auth-template := "auth-template.json"
auth-file := "auth.json"

_default:
    just --unsorted --list

# Setup synthetic.new connection
[group('setup')]
synthetic:
    pass-cli inject \
    --in-file {{ auth-template }} \
    --out-file {{ auth-file }} \
    --file-mode 0600 \
    --force
