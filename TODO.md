# TODO
### Note

- Use `pidof -s program_name` to check daemon like `sshd` or `ssh-agent`.

### Must read

- [Customizing Git - Git Attributes][git_attribute]

### Uncomplete

- [ ] Add `filter.home_user.smudge` and `filter.user_gitconfig.smudge`

### Done or almost done

- [x] Remove sensitive information

Ref https://wiki.archlinux.org/index.php/Dotfiles#Confidential_information

In `~/.gitconfig`:
```bash
git config filter.user_gitconfig.clean 'sed "/^\[alias]/p" | sed "/^\[user]/,/^\[alias]/d"'
## OR
git config filter.user_gitconfig.clean ./scripts/clean_user_gitconfig.sh
```

In `desktop.d/*.desktop` and `xfce4-keyboard-shortcuts.xml`:
```bash
git config filter.xfce_user.clean ./scripts/clean_xfce_user.sh
```

- [x] Flexible `boostrap.sh` for each Linux distrobution.

Now support both Arch and Debian Linux.

- [x] Remove `.ssh/config` that contains sensitive infos.

- [x] Fix error makes cursor cannot jumps to beginning of the line.

**Fixed:** non-printing escape sequences have to be enclosed in `\[\e[` and `\]`

[git_attribute]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes#Keyword-Expansion