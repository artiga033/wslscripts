#!/bin/sh
# This version is designed specifically for WoA devices, because mounting a vhdx to an WSL instance is supported on ARM devices.
# That requires Windows build at lease 27653, which is the canary insider channel at this time.
#
# This solution, however, uses a loopback device on the ext4.vhdx to mount a btrfs filesystem(or others is you like).
# This introduces ~40% performance down for 4k rand R-W IO, and ~20% on seq read, however ~9% increased seq write performance on btrfs,
# tested on my Surface Pro 11 with Snapdragon XElite with btrfs, no compression.
# CONSIDER TWICE before you really decided to do this.
#
# If you really care about the performance penalty,
# and your only purpose is to have a fs other than ext4 to use,
# I would suggest this: https://github.com/artiga033/WSL/releases/tag/feature-release%2Fcustom-root-fs%402.6.3
# It even makes your `/` into any fs you like.
#
# This file is considerd to be put under /usr/local/sbin/
# If you put it else where, you may also change the parameter in the systemd service.
# 
# If you are modifing this for you usage, do:
# 1. change the variables in the first servral lines
# 2. replace my username and group `artiga` with yours
# 3. change the mount command to fit your disk and partition type

img_path="/home/artiga/btrfs.img" # path to your loopback device image
device_path=/dev/disk/by-uuid/$uuid

device_path=$(losetup -f --show "$img_path")

if [ -z "$device_path" ]; then
  echo "losetup failed" >&2
  exit 1
fi

# mount the disk
# you may add other mount options here, 
# e.g. if you are not using a non-partition disk, or enabling compression for btrfs
# alse remember to change the pationtion type parameter if yours is not btrfs
mount -t btrfs $device_path $mount_point
# chagne the mount point owner to you
chown artiga:artiga $mount_point
