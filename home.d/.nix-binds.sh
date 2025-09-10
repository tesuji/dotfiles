#!/bin/sh
exec $HOME/.local/bin/bwrap \
  --unshare-user \
  --uid $UID \
  --gid $GID \
  --die-with-parent \
  --bind $HOME/.nix /nix \
  --proc /proc \
  --dev /dev \
  --tmpfs /tmp \
  --ro-bind /bin/ /bin/ \
  --ro-bind /sbin/ /sbin/ \
  --ro-bind /etc/ /etc/ \
  --ro-bind /lib/ /lib/ \
  --ro-bind /lib64/ /lib64/ \
  --ro-bind /run/ /run/ \
  --ro-bind /usr/ /usr/ \
  --dev-bind /dev/kvm /dev/kvm \
  --dev-bind /dev/dri /dev/dri \
  --bind /tmp/.X11-unix /tmp/.X11-unix \
  --bind $XDG_RUNTIME_DIR $XDG_RUNTIME_DIR \
  --bind /var /var \
  --bind $HOME $HOME \
  $HOME/.local/bin/fish

