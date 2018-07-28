# dotfiles
Collection of @lzutao dotfiles :lollipop: :sparkles: :gift:

## Disclaimer

- I do not take any responsibility for any data loss caused by this **dotfiles** repo.
- Release under [MIT License][license].
- Please do NOT link any file in `~/.ssh/` or `~/.gnupg` to this dotfiles for the sake of information security.
- If you want to backup your secret dotfiles:
  - Create a private repository called `secret_dotfiles` instead.
  - Try [Gitlab] for free private repo.
  - I would recommend having passphrases to protect all your keys.
- Currently only test for Debian-based and Arch-based distro.

## General information

| Shell    | WM / DE | Editor   | Terminal       | Multiplexer | Compositor | Audio      | Monitor | Mail        | IRC |
|:---------|:--------|:---------|:---------------|:------------|:-----------|:-----------|:--------|:------------|:----|
| bash/zsh | xfce4   | vim/subl | terminal/urxvt |             | compton    | pulseaudio | custom  | thunderbird |     |

## Installation

We need GNU Stow to install this dotfiles.

On Debian and Ubuntu
```bash
sudo apt-get install stow
```

On Arch Linux
```bash
sudo pacman -Syu --needed stow
```

Install with backup in `dotfiles/.backup`:
```bash
cd ~
git clone https://github.com/lzutao/dotfiles.git
cd dotfiles
./install.sh -b
```

Or without backup:
```bash
./install.sh
```

Now configure git:
```bash
git config --global user.name "username"
git config --global user.email "example@email.com"
```

[Tell git about your gpg key][gpg_key] if you have one.

## Known issues

- `fontconfig` may cause noised font rendering on [Fedora].

## Structures

| Folder     | Purpose                                                                                              |
|:-----------|:-----------------------------------------------------------------------------------------------------|
| .backup    | If enable, back up any old dotfiles to this folder                                                   |
| bin        | Script file expect to be in `${PATH}` like touchpad-toggling scripts                                 |
| compton    | [compton] configuration file                                                                         |
| desktop.d  | Firefox desktop file used on Debian, Zathura PDF on Arch Linux.                                      |
| home.d     | Dotfiles like `.bashrc`, `.zshrc`, etc that need linking to HOME                                     |
| icon.d     | Icon file for custome desktop file                                                                   |
| kwallet    | Autostart script to remember ssh passphrase                                                          |
| docs       | Some documentations about setting up Arch Linux and using software like git, radare2, vim, ssh, etc. |
| config.d   | All other non-important config files: elinks, qt4                                                    |
| fontconfig | Font configurations                                                                                  |
| scripts    | Useful scripts for installing Firefox, getting distro name                                           |
| subl       | SublimeText custom syntaxs and key bindings                                                          |
| urxvt      | urxvt color config and urxvtd startup file                                                           |
| xfce4      | terminal color and keyboard shortcuts config                                                         |

### subl

**Keymap**:

| Shortcut                                                | Bindings       |
|:--------------------------------------------------------|:---------------|
| <kbd>Ctrl</kbd><kbd>K</kbd>,<kbd>Ctrl</kbd><kbd>P</kbd> | Title case     |
| <kbd>Ctrl</kbd><kbd>0</kbd>                             | Reset fontsize |

**Packages**: If installed Package Control in SublimeText,
it will install the following packages:
- INI
- Markdown Table Formatter
- MasmAssembly
- NASM x86 Assembly

**Custom syntax**: bash, c, c++, css, html, java, js, makefile, python, xml.

## Contribution

If you want to help out,
there are two ways to do that.
Either you can open an [issue],
or you can fork and [pull request][pull].

## Thanks to

All other dotfiles that I stole from.
I give references in the comment of many files.
But I am too lazy to list all here.

[Fedora]:https://getfedora.org
[license]: LICENSE
[issue]: https://github.com/lzutao/dotfiles/issues
[pull]: https://github.com/lzutao/dotfiles/pulls
[Gitlab]: https://gitlab.com/
[compton]: https://wiki.archlinux.org/index.php/Compton
[gpg_key]: https://help.github.com/articles/telling-git-about-your-gpg-key/
