# Cronjobs

Cronjobs are dumped into `dotfiles/_dumps/Cronjobs`.

## Exporting Cronjobs

To export your current crontab:

```bash
./dot dump
```

Or manually:

```bash
crontab -l > ~/dotfiles/_dumps/Cronjobs
```

## Restoring Cronjobs

To restore cronjobs:

```bash
crontab ~/dotfiles/_dumps/Cronjobs
```
