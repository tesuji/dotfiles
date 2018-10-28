Contributing
============

First off, thank you for considering contributing to this dotfiles.
It's people like you that make dotfiles such a great repository.

When contributing to this repository,
please first discuss the change you wish to make via `issue`_, email,
or any other method with the owners of this repository before making a change.

Also note that there is a ``.editorconfig`` file, please follow coding style
declared in that file.

Patches and bug reports
-----------------------

Patches and bug reports are are encouraged, but please try to follow these guidelines:

- Post bug reports and patches to the `pull request`_,
  this keeps things transparent and gives everyone a chance to comment.
- The email subject line should be a specific and concise topic summary.
  Commonly accepted subject line prefixes such as ``[ANN]``, ``[PATCH]``
  and ``[SOLVED]`` are good.

Bug reports
~~~~~~~~~~~

- When reporting problems please illustrate the problem with the smallest
  possible example that replicates the issue (and please test your example
  before posting). This technique will also help to eliminate red herrings
  prior to posting.
- Paste the commands that you executed along with any relevant outputs.
- Include the SHA-1 hash of commit of **dotfiles** and the platform you're
  running it on.
- If you can program please consider writing a patch to fix the problem.

Patches
~~~~~~~

- Keep patches small and atomic (one issue per patch) - no patch bombs.
- If possible test your patch against the current trunk.
- If your patch adds or modifies functionality include a short example that
  illustrates the changes.
- Send patches in ``diff -u`` format, inline inside the mail message is usually
  best; if it is a very long patch then send it as an attachment.
- Include documentation updates if you're up to it; otherwise insert TODO
  comments at relevant places in the documentation.


.. _issue: https://github.com/lzutao/dotfiles/issues
.. _pull request: https://github.com/lzutao/dotfiles/pulls

Directory Hierarchy
-------------------

If you add a new dotfile to this repo, please add it in appropriate directory.

.. code:: sh

    % tree -d
    .
    ├── bin                 Contain any back-up dotfiles before installing
    ├── compton             Useful scripts: e.g. toggle-touchpad
    ├── config.d            All other non-important config files: elinks, qt4
    ├── desktop.d           Desktop files used on Debian, Zathura PDF in Arch Linux
    ├── docs                Some guidances about setting up Arch Linux and git, r2, vim,
    ├── firefox             Advanced settings to tweak and customize Firefox
    ├── fontconfig          Font configuration helps dealing with Microsoft fonts
    ├── home.d              Dotfiles like ``.bashrc``, ``.zshrc``, etc that need to link to HOME
    ├── icon.d              Icon file for custom desktop files
    ├── kdewallet           Autostart script to remember ssh passphrase
    ├── mercurial           Some experimental Mercurial SCV configurations
    ├── scripts             Useful scripts for installing Firefox, getting distro name
    │   ├── git                 Filter for Git
    │   └── postins             Post-installation script for Linux distributions (Ubuntu)
    ├── src                 [WIP] Try to generate dotfiles from Python
    │   └── home                Generate home dotfiles
    ├── subl                Sublime Text custom syntax and key bindings
    ├── tmux                tmux configuration and supporting scripts
    ├── urxvt               urxvt color config and urxvtd startup file
    ├── vscode              Global settings of Visual Code
    ├── xfce4               Terminal color and keyboard shortcuts
    └── zsh_completions     Additional zsh completion scripts (PIP)

    26 directories
