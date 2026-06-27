# Cronjobs

Cronjobs are dumped into `dotfiles/data/Cronjobs`.

## Exporting Cronjobs

To export your current crontab:

```bash
./dot dump
```

Or manually:

```bash
crontab -l > ~/dotfiles/data/Cronjobs
```

## Restoring Cronjobs

To restore cronjobs:

```bash
crontab ~/dotfiles/data/Cronjobs
```
