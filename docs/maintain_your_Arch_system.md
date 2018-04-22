# General recommendations to maintain your Arch Linux system

### Check new keyring
`sudo pacman-key --populate archlinux`

### Broken symlinks

Old, broken symbolic links might be sitting around your system; you should remove them. Examples on achieving this can be found here and here.

To quickly list all the broken symlinks of your system, use:

```bash
sudo find /etc/alternatives -xtype l -exec rm {} +    # With Debian 9 Stretch
sudo find / -not -path '/proc/*' -not -path '/run/*' -xtype l -print 2>/dev/null
```

Then inspect and remove unnecessary entries from this list.

### Removing unused packages (orphans)

For recursively removing orphans and their configuration files:

```bash
sudo pacman -Rns $(pacman -Qtdq)
```

If no orphans were found, pacman errors with error: no targets specified. This is expected as no arguments were passed to `pacman -Rns`.

### Database access speeds

Pacman stores all package information in a collection of small files, one for each package. Improving database access speeds reduces the time taken in database-related tasks, e.g. searching packages and resolving package dependencies. The safest and easiest method is to run as root:

`sudo pacman-optimize`

This will attempt to put all the small files together in one (physical) location on the hard disk so that the hard disk head does not have to move so much when accessing all the data. This method is safe, but is not foolproof: it depends on your filesystem, disk usage and empty space fragmentation. Another, more aggressive, option would be to first remove uninstalled packages from cache and to remove unused repositories before database optimization:

`sudo pacman -Sc && sudo pacman-optimize`
