dotfiles
========

Collection of @lzutao dotfiles.

Currently only tested for Debian-based and Arch-based distro.

General Information
-------------------

+------------+---------+------------+------------------+-------------+------------+------------+---------+------+-----+
| Shell      | WM / DE | Editor     | Terminal         | Multiplexer | Compositor | Audio      | Monitor | Mail | IRC |
+============+=========+============+==================+=============+============+============+=========+======+=====+
| bash / zsh | XFCE    | VIM / Subl | terminal / urxvt | tmux        | compton    | pulseaudio | custom  |      |     |
+------------+---------+------------+------------------+-------------+------------+------------+---------+------+-----+

tmux
~~~~

Try to be compatible with tmux 1.8 and 2.3+.
Use :kbd:`Ctrl`-:kbd:`Space` as prefix key.

zsh
~~~

Manual configuration (no dependencies).

**Preview**:

|preview_shell|
|preview_vim|

subl
~~~~

**Keymap**:

+------------------------------+---------------------------+
| Shortcut                     | Bindings                  |
+==============================+===========================+
| :kbd:`Ctrl+K`, :kbd:`Ctrl+P` | Title case                |
+------------------------------+---------------------------+
| :kbd:`Ctrl+0`                | Reset font size           |
+------------------------------+---------------------------+
| :kbd:`Ctrl+T`                | Trim trailing whitespaces |
+------------------------------+---------------------------+

**Installed package**: If already installed Package Control in Sublime Text,
Package Control will install the following packages:

- Autotools
- Markdown Table Formatter
- MasmAssembly
- NASM x86 Assembly
- Package Control
- TOML

**Custom syntax**: bash, c, c++, css, html, java, js, makefile, python, xml.

Firefox
~~~~~~~

Install tweak by:

.. code:: sh

    sh ./scripts/tweak_firefox.sh

Getting Started
---------------

These instructions will get you a copy of the project up and running on
your local machine.

Prerequisites
~~~~~~~~~~~~~

GNU Stow is needed for installing this dotfiles,
to install ``stow``,
use the following command in proper distribution.

+---------------------+--------------------------------------+
| Distro              | Command                              |
+=====================+======================================+
| Debian and Ubuntu   | ``sudo apt-get install stow``        |
+---------------------+--------------------------------------+
| Arch Linux          | ``sudo pacman -Syu --needed stow``   |
+---------------------+--------------------------------------+

Installation
~~~~~~~~~~~~

Install with backup in ``dotfiles/.backup``:

.. code:: bash

    cd ~
    git clone https://github.com/lzutao/dotfiles.git
    cd dotfiles
    ./install.sh -b

Or without backup:

.. code:: bash

    ./install.sh

Now configure git:

.. code:: bash

    git config --global user.name "username"
    git config --global user.email "example@email.com"

`Telling Git about your signing key <https://help.github.com/articles/telling-git-about-your-signing-key/>`_ if you have one.

Known Issues
------------

-  ``fontconfig`` may cause noised font rendering on `Fedora`_.

Contributing
------------

Please read `<CONTRIBUTING.rst>`__ for details on our code of conduct,
and the process for submitting pull requests to us.

Thanks To
---------

All other dotfiles that I stole from.
I give references in the comment of many files.
But I am too lazy to list all here.

See also the list of `contributors`_ who participated in this project.

License
-------

This project is licensed under the MIT License - see the `<LICENSE>`__ file for details.

.. _Gitlab: https://gitlab.com
.. _contributors: https://github.com/lzutao/dotfiles/graphs/contributors
.. _Fedora: https://getfedora.org
.. _compton: https://wiki.archlinux.org/index.php/Compton
.. |preview_shell| image:: docs/img/zsh_preview.png
.. |preview_vim| image:: docs/img/zsh_vim_view.png
