#!/bin/sh
# If use with bash, export argv="$@"
# Cannot ise tmpfs since pwntools shares gdb scripts between tmux panes.
#--tmpfs /tmp \
[ ! -d /tmp/$UID ] \
  && rm -f /tmp/$UID \
  && mkdir /tmp/$UID

# fakeroot broke with --unshare-user
# --unshare-user --uid $UID --gid $GID
exec \
$HOME/.local/bin/bwrap \
  --die-with-parent \
  --bind $HOME/.nix /nix \
  --proc /proc \
  --dev /dev \
  --ro-bind /bin/ /bin/ \
  --ro-bind /sbin/ /sbin/ \
  --ro-bind /etc/ /etc/ \
  --ro-bind /lib/ /lib/ \
  --ro-bind /lib64/ /lib64/ \
  --ro-bind /run/ /run/ \
  --ro-bind /usr/ /usr/ \
  --ro-bind /sys/ /sys/ \
  --dev-bind /dev/kvm /dev/kvm \
  --dev-bind /dev/vfio /dev/vfio \
  --dev-bind /dev/vhost-vsock /dev/vhost-vsock \
  --dev-bind /dev/vhost-net /dev/vhost-net \
  --dev-bind /dev/net /dev/net \
  --bind /tmp/$UID/ /tmp/ \
  --bind /tmp/tmux-$UID/ /tmp/tmux-$UID/ \
  --bind $XDG_RUNTIME_DIR $XDG_RUNTIME_DIR \
  --bind /var /var/ \
  --bind /run/tmux/$UID/ /run/tmux/$UID/ \
  --bind $HOME $HOME \
  $argv

