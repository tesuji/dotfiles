# How to install Arch Linux

**Updated:** April 18th 2018

## Starting The Setup Process

### Download the Arch installation image

Go to [Arch Linux](https://www.archlinux.org/download/) homepage and download the Arch Linux iso

### Burn the iso to a blank disc

#### On Linux

Find out the name of USB drive with `lsblk`. Make sure that it is **not** mounted.

Run the following command, replacing `/dev/sdx` with drive, e.g. `/dev/sdb`. (Do **not** append a partition number, so do **not** use something like `/dev/sdb1`)

```bash
sudo dd bs=4M if='path_to_iso' of='path_to_usb' status=progress oflag=sync
```

Example: asume usb is in `/dev/sdb` and `iso` image in `home`, then type this
```bash
sudo dd bs=4M if='/home/username/ArchLinux.iso' of='/dev/sdb' status=progress oflag=sync
```

**Note**: To restore the USB drive as an empty, usable storage device after using the Arch ISO image, the iso9660 filesystem signature needs to be removed by running `wipefs --all /dev/sdx` as root, before [repartitioning](https://wiki.archlinux.org/index.php/Repartition) and [reformating](https://wiki.archlinux.org/index.php/Reformat) the USB drive.

#### On Windows

Use [Rufus](https://rufus.akeo.ie) to burn iso to installation media

**Note**: Be sure to select **DD image** mode from the dropdown menu or the image will be transferred [incorrectly](https://wiki.archlinux.org/index.php/USB_flash_installation_media#Using_Rufus).

#### On mac

Plug usb into mac

In terminal, type this : `diskutil list`. Then check usb from the output
using the amount of data.

Let assume it is `/dev/disk3`

Then unmount the usb : `diskutil unmountDisk /dev/disk3`

And run this command: `sudo dd if='path_to_iso' of='/dev/disk3' bs=1M && sync`

### Backup any data on computer or the drive you are installing Arch Linux on.

### Insert the installation media to computer

- Press the key that allows you to change the boot order
- On most newer computers, this is `F12`. through the exact key should
be displayed on the screen during boot up.
- Select `Boot from Arch Linux (x86_64)`

If you are booting in UEFI mode then choose `Archiso x86_64 UEFI`

### Connect to the Internet
The connection may be checked with:
```bash
ping archlinux.org
```

If no connection is available, stop the *dhcpcd* service with `systemctl stop dhcpcd@` and press `Tab`.

This command `ping www.google.com > /dev/null 2>&1 &` will keep internet from being interrupted by long unusing time.

If you have an **authoried internet access**, use `elinks` with `javascript` to login:

- type `elinks archlinux.org`
- press the `Esc` key. Press `o` to open `Options manager`
- move the cursor to `ECMAScripts` and press the space bar, select the `Enable` field and use right arrow to move to `Edit` option
- type `1` to the value and use the down arrow key to `OK`
- press the right arrow key to move to `Save` option and choose `OK`
- press `g` and type `archlinux.org` or anything else to access the login page. The else part is .

### Update the system clock

Ensure the system clock is accurate:
```bash
timedatectl set-ntp true
```

To check the service status, use timedatectl status.

## Set Up Partitions

> You can use Linux Live CD like `Ubuntu` and software `GParted` on it or with
> `Disk Management` on `Windows` to partition the hard disk. But I discourage
> these way.

If you want to manually set up partitions, follow these:

* Type `lsblk` to see the name of partitions, like `/dev/sda1`.
And make note the partitions you use for Arch

* We use at least 3 partitions here - one for the OS, one for `/home` and
one for `swap`. You could also modify more partitions meet need like
for `/boot`, etc... **or** remove `/home` partition, just `root` partition
is enough for beginners.

* Sometimes you will have `/dev/sda` as USB installation media and
`/dev/sdb` as main hard drive, the drive you use to install `Arch`.
But in this tutorial, I will assume that `/dev/sda` is the disk you want
to install Arch Linux.

* If you want to erase all disk to install only Arch Linux,
type `sgdisk --zap-all /dev/sda`

### Check if you are using a UEFI motherboard.

Type `stat /sys/firmware/efi/efivars`, if the result is `No such file or directory`
then boot mode is `Legacy BIOS`.

### Create GPT partition (only `UEFI`)

You will need to create an extra EFI partition as well. In this example, we will be
creating a Root partition, a Swap partition, a Home partition, and an EFI partition

* Start `cgdisk` (or `cfdisk`) by typing `cgdisk /dev/sda` and press `Enter`

* Select `New` and then press `Enter` to select first sector, type the size you
want for Root partition, I recommend it as 25G. After that,
press `Enter` 2 times to create it.

* Press down arrow key until the remaining free space is selected.
Press `Enter` to select first sector, type the size you want for
Swap partition, a half of RAM. Then also press `Enter` 2 times to create it.

* Press down arrow key until the remaining free space is selected.
Press `Enter` to select first sector, type the size you want for Home partition.
I think it should be minimum as 20G but make sure to leave at least
500MB for EFI partition. Then also press `Enter` 2 times to create it.

* Press down arrow key until the remaining free space is selected. Press
`Enter` to select first sector, type the size you want for EFI partition,
make sure to leave at least 500MB for EFI partition.
Then also press `Enter` 2 times to create it.

* Select `Write` to write the new partition to the disk.
Type `yes` and choose `Quit` to exit `cgdisk`.

### Create MBR partition (only `Legacy BIOS`)

Type `cfdisk /dev/sda`

I am going to use `cfdisk` to set up 3 partitions :

* Root partition, `/dev/sda1` as primary bootable with size of 25G and ext4 formatted

* Swap partition, `/dev/sda2` as primary with size half of RAM

* Logical partition, `/dev/sda5` as '/home', rest of the space and ext4 formatted.

#### Step 1. Create primary partition

Select **New**, enter partition size `25G` in my case

Then, select **Type**, choose `Linux` format (alias for ext4 format)

Next, choose `Bootable` to make this partition as bootable partition

Then, select ***Write*** using left/right arrow key to write partition changes.
Type **Yes** to save the changes.

#### Step 2. Create `swap` partition

Select **New**, enter partition size `2G` in my case, remember it is half of you RAM

Then, select **Type**, choose `Linux Swap/Solaris` format

Then, select ***Write*** using left/right arrow key to write partition changes.
Type **Yes** to save the changes.

#### Step 3. Create logical (extended) partition

Select **New**, enter partition size. Since it is the last partition, I just
press enter to select rest of the disk space for this partition.

Then, select **Type**, choose `Linux extended` format

Then, select the free space after it and select **New**

Then, select **Type**, choose `Linux` format (alias for `ext4` format)

Then, select ***Write*** using left/right arrow key to write partition changes.
Type **Yes** to save the changes.

> After creating the necessary partitions, select `Quit` option and exit the
> partition manager. You can use `lsblk` or `fdisk -l` to verify partition details

### Format partitions

> Remember this step will delete all data in these partitions, so if you already have
> a partition such as `/home` on old `Ubuntu` system and want to mount it, jump to part 5

```bash
# format / and home partition
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda5

mkswap /dev/sda2
swapon /dev/sda2
#########################
# Only for GPT partition
# format EFI partition
# assume it is sda7
# use `lsblk` to find
#########################
mkfs.fat -F32 /dev/sda7
```

### Mount partitions

Type the following commands:

```bash
# create /home and /mnt directory for mounting
mkdir -p /mnt/home
mount /dev/sda1 /mnt
mount /dev/sda5 /mnt/home
```

## Installing Arch Linux

### Select the mirrors

You could also visit [this page](https://www.archlinux.org/mirrorlist/) on another computer
and use the tool to find the closest mirror to physical location.
Copy the address down. It may help to write down a few mirrors in case one is offline.

The mission is **change the first** `Server =` line in
`/etc/pacman.d/mirrorlist` to new primary mirror.

Use `vi /etc/pacman.d/mirrorlist`.

Scroll down to preferred mirror (the closer to location the better), press `yy` to copy.

Then scroll back up and press `p` to paste the line at the top of the list.

Then press `Esc` and type `:x` to save and exit the `vi` program.

### Install the Arch Base System

Type the following command

```bash
pacstrap -i /mnt base base-devel
```

And wait until finishing. The waiting time depends on Internet speed.

## Configure the system

### Fstab
Generate an fstab file (use `-U` or `-L` to define by UUID or labels, respectively):
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Check the resulting file in `/mnt/etc/fstab` afterwards, and edit it in case of errors.

### Chroot
[Change root](https://wiki.archlinux.org/index.php/Change_root) into the new system:

```bash
arch-chroot /mnt
```

### Time zone
Set the [time zone](https://wiki.archlinux.org/index.php/Time_zone) and run [hwclock(8)](https://jlk.fjfi.cvut.cz/arch/manpages/man/hwclock.8) to generate `/etc/adjtime` (assumes the hardware clock is set to UTC):

```bash
ln -fs /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
hwclock --systohc
```

### Locale
First, install `vim`:
```bash
pacman -S vim git
pacman -Rns vi
alias vi=vim
```

Type `vi /etc/locale.gen`. Uncomment `en_US.UTF-8 UTF-8`, `en_GB.UTF-8 UTF-8` in `/etc/locale.gen`, and generate them with:
```bash
locale-gen
```

Set the LANG variable in `locale.conf(5)` accordingly:
```bash
echo -n 'LANG=en_US.UTF-8' > /etc/locale.conf
## alternative, run
localectl set-locale LANG=en_US.UTF-8
```

### Set hostname

Create the [hostname](https://wiki.archlinux.org/index.php/Hostname) file and add matching entries to `hosts(5)`:

```bash
$ echo myhostname > /etc/hostname
$ tee -a /etc/hosts <<-EOF
127.0.0.1    localhost
::1          localhost
127.0.1.1    myhostname.localdomain    myhostname
EOF
```

If the system has a permanent IP address, it should be used instead of `127.0.1.1`

### Network configuration

##### 1. Wired

There are many solutions to choose from, but remember that all of them are mutually exclusive;
you should **NOT** run two daemons simultaneously.

The following table compares the different connection managers. *Automatically handles
wired connection* means that there is at least one option for the user to simply start
the daemon without creating a configuration file.

| Connection manager | Automatically handles wired connection | Official GUI | Archiso    | Console tools | Systemd units                                      |
|:-------------------|:---------------------------------------|:-------------|:-----------|:--------------|:---------------------------------------------------|
| ConnMan            | Yes                                    | No           | No         | connmanctl    | connman.service                                    |
| dhcpcd             | Yes                                    | No           | Yes (base) | dhcpcd        | dhcpcd.service, dhcpcd@interface.service           |
| netctl             | Yes                                    | No           | Yes (base) | netctl        | netctl-ifplugd@interface.service                   |
| NetworkManager     | Yes                                    | Yes          | No         | nmcli,nmtui   | NetworkManager.service                             |
| systemd-networkd   | No                                     | No           | Yes (base) |               | systemd-networkd.service, systemd-resolved.service |
| Wicd               | Yes                                    | Yes          | No         | wicd-curses   | wicd.service                                       |

Example:
```bash
pacman -S networkmanager network-manager-applet
systemctl enable NetworkManager
```

##### 2. Wireless

For Wireless configuration, install the `iw` and `wpa_supplicant` packages, as well as needed [firmware packages](https://wiki.archlinux.org/index.php/Wireless#Installing_driver.2Ffirmware).
Optionally install `dialog` for usage of *wifi-menu*.

```bash
pacman -S iw wpa_supplicant
```

### Configure package manager

Type `vi /etc/pacman.conf`. Scroll down and uncomment these line
```bash
[multilib]
Include = /etc/pacman.d/mirrorlist
```
Save changes and exit.

After that, type `pacman -Sy` to refresh reposity list.

### Create a normal user

Because being `root` user when using normal task is dangerous, you could destroy
all system by mistake when you are `root` user.

Replace myusername with username, type the following commands
```bash
useradd -m -G power,storage,wheel myusername
passwd myusername
```

Now install the `sudo` package, `sudo` will let you have `superuser` privilege
when you need. Type these commands:
```bash
pacman -S sudo --needed
visudo
```

Scroll down and uncomment this line: `%wheel ALL=(ALL) ALL`. Save and exit the editor.

### Configure the bootloader
This is the software that loads the OS when computer starts.
If you're doing **dual boot**, type this :
```bash
pacman -S os-prober
```

#### Only UEFI
Mount **efi** partition:
```bash
#########################
# Only for GPT partition
#########################
mkdir /boot/EFI
mount /dev/sda7 /boot/EFI
```

Type these commands:
```bash
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck /dev/sda
```

#### Only Legacy BIOS
Type these commands:
```bash
pacman -S grub-bios
grub-install --target=i386-pc --recheck /dev/sda
```

#### Both UEFI and BIOS
Type these commands:
```bash
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg
```

If you have an **Intel CPU**, install the `intel-ucode` package in addition, and
[enable microcode updates](https://wiki.archlinux.org/index.php/Microcode#Enabling_Intel_microcode_updates).

## Reboot computer
Exit from chroot, unmount partitions and reboot you computer. Type:

```bash
exit
umount -R /mnt
reboot
```

If noticing any "busy" partitions, find the cause with `fuser(1)`.

Remember to remove the installation media at this time.

### Sign in after Arch boots up
Use the password you created as a normal user to log in.

### Install GUI : Get Desktop Up And Running (XFCE4 as default)

#### Install `bash-completion`
`sudo pacman -S bash-completion`

#### Enable `AUR` reposity
`AUR` is one of the best of Arch Linux with community maintain packages.

##### PacAUR (not maintained)
> From http://cdavis.us/wiki/index.php/Arch_Linux_Install_Guide

##### General steps for others <aur helpers>

+ Now install `<aur_helpers>`
```bash
mkdir -p ~/.aur/aur_helpers && cd $_
gpg --keyserver pgp.mit.edu --recv-keys <key_id>
git clone https://aur.archlinux.org/<aur_helpers>.git
cd <aur_helpers>
makepkg -si PKGBUILD
```

**More:** https://wiki.archlinux.org/index.php/makepkg#Improving_compile_times

#### If you have trouble with `Wi-Fi`
Google for install `wifi driver for arch`

#### Disable `root` user account
For safe, type `sudo passwd -dl root`

#### Install XFCE4 Dekstop, Sreen locker and Sound Server
We have chosen to install

- `xorg` as display server (must be **manually** installed)
- Intel GPU driver (`xf86-video-intel`) as graphics driver
	+ If you use Nvidia (latest card): `nvidia nvidia-libgl`
	+ For ATI/AMD: `xf86-video-ati lib32-mesa-libgl`
- `lightdm` or `lxdm` as display manager
- and `xfce4` as desktop environment

##### 1) Install Intel GPU driver
```
sudo pacman -S xorg xorg-server
sudo pacman -S xf86-video-intel
```

If Arch is in VMWare, just install `xf86-input-vmmouse`, `xf86-video-vmware`,
`open-vm-tools` and enable `vmtoolsd` by `sudo systemctl enable vmtoolsd`

##### 2) Install display manager

Choose either **a)** or **b)** for installing desktop manager
###### a) Install LXDM (Light X11 Desktop Manager)

Install desktop manager **LXDM** and Sreen locker **XScreenSaver**

`sudo pacman -S lxdm xscreensaver`

Then type `sudo vi /etc/lxdm/lxdm.conf` and change line `session=/usr/bin/startlxde`
to `session=/usr/bin/startxfce4`. Save change and exit.

Then, type `sudo systemctl enable lxdm`
###### b) Install LightDM

Install desktop manager **LightDM** and screen locker **light-locker**

```
sudo pacman -S xorg-server-xephyr accountsservice
sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings light-locker
```
where:
- `accountsservice` for *Enhanced user accounts handling*
- `xorg-server-xephyr` for *LightDM test mode*

Change the `[Seat:*]` section of the LightDM configuration file in
`/etc/lightdm/lightdm.conf`, like so
```bash
[Seat:*]
...
greeter-session=lightdm-gtk-greeter
```

Then, run LightDM as an X application:
```
$ sudo lightdm --test-mode --debug
```

Then type `sudo systemctl enable lightdm`

##### 3) Install desktop environment

Install **XFCE4** desktop environment and sound server **ALSA**
```
sudo pacman -S xfce4 pulseaudio pavucontrol xfce4-pulseaudio-plugin alsa-utils
```

### Finally, reboot system with `reboot`
If it does not work, type `reboot -f` to force it to reboot.