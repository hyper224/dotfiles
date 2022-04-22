# dotfiles

Prerequisite

- `rsync`

Install dotfiles

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hyper224/dotfiles/main/.tools/install.sh)"
```

Configuration

- Do not show untracked files

```sh
config config --local status.showUntrackedFiles no
```

Remove dotfiles

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hyper224/dotfiles/main/.tools/uninstall/uninstall.sh)"
```
