Contributing
============

Please first reference the `Shell Style Guilde`_ of Google.
Then discuss the change you wish to make via `issue`_.

Also note that there is a ``.editorconfig`` file, please follow coding style
declared in that file.

Patches and bug reports
-----------------------

- Post bug reports and patches to the `pull request`_,
  this keeps things transparent and gives everyone a chance to comment.

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

.. _issue: https://github.com/lzutao/dotfiles/issues
.. _pull request: https://github.com/lzutao/dotfiles/pulls
.. _Shell Style Guilde: https://google.github.io/styleguide/shell.xml

Directory Hierarchy
-------------------

If you add a new dotfile to this repo, please add it in appropriate directory.

.. code:: sh

    % tree -d
    .
    ├── bin                 Useful scripts: e.g. toggle-touchpad
    ├── compton             Configuration of compton -- a compositor for X11
    ├── config.d            All other non-important config files: elinks, qt4
    ├── desktop.d           Desktop files used on Debian, Zathura PDF in Arch Linux
    ├── docs                Some guidances about setting up Arch Linux and git, r2, vim,
    ├── firefox             Advanced settings to tweak and customize Firefox
    ├── fontconfig          Font configuration helps dealing with Microsoft fonts
    ├── home.d              Dotfiles like ".bashrc", ".zshrc", etc that need to link to HOME
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

Zsh/Bash startup files loading order (.bashrc, .zshrc etc.)
-----------------------------------------------------------

If you have ever put something in a file like ``.bashrc`` and had it not work,
or are confused by why there are so many different files --
``.bashrc``, ``.bash_profile``, ``.bash_login``, ``.profile`` etc. --
and what they do, this is for you.

The issue is that Bash sources from a different file based on what kind of
shell it thinks it is in. For an interactive **non-login** shell,
it reads ``.bashrc``, but for an interactive **login** shell it reads from the
first of ``.bash_profile``, ``.bash_login`` and ``.profile`` (only).
There is no sane reason why this should be so; it's just historical.

For Bash, they work as follows. Read down the appropriate column.
Executes A, then B, then C, etc. The B1, B2, B3 means it executes only
the first of those files found.

+----------------------+-------------------+-----------------------+--------+
|                      | Interactive login | Interactive non-login | Script |
+======================+===================+=======================+========+
| ``/etc/profile``     | A                 |                       |        |
+----------------------+-------------------+-----------------------+--------+
| ``/etc/bash.bashrc`` |                   | A                     |        |
+----------------------+-------------------+-----------------------+--------+
| ``~/.bashrc``        |                   | B                     |        |
+----------------------+-------------------+-----------------------+--------+
| ``~/.bash_profile``  | B1                |                       |        |
+----------------------+-------------------+-----------------------+--------+
| ``~/.bash_login``    | B2                |                       |        |
+----------------------+-------------------+-----------------------+--------+
| ``~/.profile``       | B3                |                       |        |
+----------------------+-------------------+-----------------------+--------+
| ``$BASH_ENV``        |                   |                       | A      |
+----------------------+-------------------+-----------------------+--------+
| ``~/.bash_logout``   | C                 |                       |        |
+----------------------+-------------------+-----------------------+--------+

For Zsh:

+-------------------+-------------------+-----------------------+--------+
|                   | Interactive login | Interactive non-login | Script |
+===================+===================+=======================+========+
| ``/etc/zshenv``   | A                 | A                     | A      |
+-------------------+-------------------+-----------------------+--------+
| ``~/.zshenv``     | B                 | B                     | B      |
+-------------------+-------------------+-----------------------+--------+
| ``/etc/zprofile`` | C                 |                       |        |
+-------------------+-------------------+-----------------------+--------+
| ``~/.zprofile``   | D                 |                       |        |
+-------------------+-------------------+-----------------------+--------+
| ``/etc/zshrc``    | E                 | C                     |        |
+-------------------+-------------------+-----------------------+--------+
| ``~/.zshrc``      | F                 | D                     |        |
+-------------------+-------------------+-----------------------+--------+
| ``/etc/zlogin``   | G                 |                       |        |
+-------------------+-------------------+-----------------------+--------+
| ``~/.zlogin``     | H                 |                       |        |
+-------------------+-------------------+-----------------------+--------+
| ``~/.zlogout``    | I                 |                       |        |
+-------------------+-------------------+-----------------------+--------+
| ``/etc/zlogout``  | J                 |                       |        |
+-------------------+-------------------+-----------------------+--------+

Note that Zsh reads ``~/.profile`` only if ``~/.zshrc`` is not present.

References
~~~~~~~~~~

- [1]_ Difference between .bashrc and .bash_profile
- [2]_ Startup files loading after bashrc and zshrc
- [3]_ Explain non-login interactive shell
- [4]_ Different between login and non-login shell
- [5]_ All startup files of zsh
- [6]_ Bash startup files
- [7]_ Zsh not hitting ~/.profile

.. [1] https://superuser.com/a/183980/510572
.. [2] https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
.. [3] https://superuser.com/questions/657848/why-do-we-have-login-non-login-interactive-and-non-interactive-bash-shells
.. [4] https://unix.stackexchange.com/questions/38175/difference-between-login-shell-and-non-login-shell?noredirect=1&lq=1
.. [5] http://zsh.sourceforge.net/Guide/zshguide02.html
.. [6] https://www.gnu.org/software/bash/manual/bashref.html#Bash-Startup-Files
.. [7] https://superuser.com/a/892248/510572
