# TODO
### Note

- Use `pidof -s program_name` to check daemon like `sshd` or `ssh-agent`.

### Must read

- [Customizing Git - Git Attributes][git_attribute]

### Uncomplete

- [ ] Remove sensitive information

Ref https://wiki.archlinux.org/index.php/Dotfiles#Confidential_information

In `~/.gitconfig`:
```bash
git config filter.strip_git_user.clean 'sed -E "s/(^\s*name\s*=\s*)\w*/\1user/" -E "s/[a-zA-Z0-9.!#$%&'*+\-\/=?^_`{|}~]+@[a-zA-Z0-9\-]+.\w+/\1example@email.com/" -E "s/(^\s*signingkey\s*=\s*)[0-9A-Z]{16}/\1DEAFBEEFCAFEBABY/"'
## OR
git config filter.strip_git_user.clean 'sed "/^\[alias]/p" | sed "/^\[user]/,/^\[alias]/d"'
```

In `desktop.d/*.desktop` and `xfce4-keyboard-shortcuts.xml`:
```bash
git config filter.home_user.clean 'sed -E "s/(\/home\/)[a-z_][a-z0-9_]{0,30}/\1user/"'
```

### Done or almost done

- [x] Flexible `boostrap.sh` for each Linux distrobution.

Now support both Arch and Debian Linux.

- [x] Remove `.ssh/config` that contains sensitive infos.

- [x] Fix error makes cursor cannot jumps to beginning of the line.

**Fixed:** non-printing escape sequences have to be enclosed in `\[\e[` and `\]`

[git_attribute]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes#Keyword-Expansion