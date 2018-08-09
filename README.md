# dotfiles

Collection of @lzutao dotfiles :lollipop: :sparkles: :gift:

## Disclaimer

- I do not take any responsibility for any data loss caused by this **dotfiles** repo.
- Release under [MIT License][license-mit].
- Please do NOT link any file in `~/.ssh/` or `~/.gnupg` to this dotfiles for the sake of information security.
- If you want to backup your secret dotfiles:
  - Create a private repository called `secret_dotfiles` instead.
  - Try [Gitlab] for free private repo.
  - I would recommend having passphrases to protect all your keys.
- Currently only tested for Debian-based and Arch-based distro.

## General Information

| Shell      | WM / DE | Editor     | Terminal         | Multiplexer | Compositor | Audio      | Monitor | Mail | IRC |
|:-----------|:--------|:-----------|:-----------------|:------------|:-----------|:-----------|:--------|:-----|:----|
| bash / zsh | XFCE    | VIM / Subl | terminal / urxvt |             | compton    | pulseaudio | custom  |      |     |

### zsh

Manual configuration (no dependencies),
not full feature but at least good enough.

**Preview**: ![preview][zsh_preview]

## Dependencies

GNU Stow is needed for installing this dotfiles,
to install `stow`,
use the following command in proper distribution.

| Distro            | Command                          |
|:------------------|:---------------------------------|
| Debian and Ubuntu | `sudo apt-get install stow`      |
| Arch Linux        | `sudo pacman -Syu --needed stow` |

## Installation

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

[Tell git about your GPG key][gpg_key] if you have one.

## Known Issues

- `fontconfig` may cause noised font rendering on [Fedora].

## Directory Hierarchy

| Folder     | Description                                                           |
|:-----------|:----------------------------------------------------------------------|
| .backup    | Contain any back-up dotfiles before installing this repo              |
| bin        | Some useful shell scripts such as touchpad-toggling                   |
| compton    | Configuration of `compton` - a compositor for X11                     |
| config.d   | All other non-important config files: elinks, qt4                     |
| desktop.d  | Firefox desktop file used on Debian, Zathura PDF in Arch Linux        |
| docs       | Some guidances about setting up Arch Linux and git, r2, vim, ssh, etc |
| firefox    | Advanced settings to tweak and customize Firefox                      |
| fontconfig | Font configuration helps dealing with Microsoft fonts                 |
| home.d     | Dotfiles like `.bashrc`, `.zshrc`, etc that need to link to HOME      |
| icon.d     | Icon file for custom desktop files                                    |
| kdewallet  | Autostart script to remember ssh passphrase                           |
| scripts    | Useful scripts for installing Firefox, getting distro name            |
| subl       | Sublime Text custom syntax and key bindings                           |
| urxvt      | urxvt color config and urxvtd startup file                            |
| vscode     | Global settings of Visual Code                                        |
| xfce4      | Terminal color and keyboard shortcuts                                 |

### subl

**Keymap**:

| Shortcut                                                | Bindings        |
|:--------------------------------------------------------|:----------------|
| <kbd>Ctrl</kbd><kbd>K</kbd>,<kbd>Ctrl</kbd><kbd>P</kbd> | Title case      |
| <kbd>Ctrl</kbd><kbd>0</kbd>                             | Reset font size |

**Installed package**:
If installed Package Control in SublimeText,
it will install the following packages:

- Autotools
- CMake
- INI
- Markdown Table Formatter
- MasmAssembly
- Meson
- NASM x86 Assembly

**Custom syntax**: bash, c, c++, css, html, java, js, makefile, python, xml.

### Firefox

Install tweak by:
```bash
bash ./scripts/tweak_firefox.sh
```

## Contribution

If you want to help out,
there are two ways to do that.
Either you can open an [issue],
or you can fork and [pull request][pull].

## Thanks To

All other dotfiles that I stole from.
I give references in the comment of many files.
But I am too lazy to list all here.

[Fedora]: https://getfedora.org
[license-mit]: LICENSE
[issue]: https://github.com/lzutao/dotfiles/issues
[pull]: https://github.com/lzutao/dotfiles/pulls
[Gitlab]: https://gitlab.com/
[compton]: https://wiki.archlinux.org/index.php/Compton
[gpg_key]: https://help.github.com/articles/telling-git-about-your-gpg-key/
[zsh_preview]: docs/img/zsh_preview.png
