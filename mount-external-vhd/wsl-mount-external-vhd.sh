#!/bin/sh
# This file is considerd to be put under /usr/local/sbin/
# If you put it else where, you may also change the parameter in the systemd service.
# 
# If you are modifing this for you usage, do:
# 1. change the variables in the first servral lines
# 2. replace my username and group `artiga` with yours
# 3. change the mount command to fit your disk and partition type

wsl='/mnt/c/Windows/system32/wsl.exe' # path to wsl.exe on the Windows side, change if your windows system drive is not `C`
vhd='G:\btrfs.vhdx' # Path to you vhdx on the windows side.
uuid=af93b88a-5618-4acd-ae0a-e26ecf3de7c6 # your partition uuid, you may check it by `lsblk -f`
mount_point=/home/artiga # mountpoint
device_path=/dev/disk/by-uuid/$uuid
timeout=100 # in microseconds

# call the wsl.exe to mount our vhd
$wsl --mount --vhd $vhd --bare

# the wsl command finishes a bit earlier than the mount operation
# we may wait for sometime
# generally this won't be longer than 100ms, 
# if not, you may configure the timeout variable above
count=0
while [ ! -e "$device_path" ]
do
  echo "Waiting for $uuid to be available..."
  sleep 0.01
  ((count = $count + 10))
  if [ $count -gt $timeout ]; then
    echo "TIMED OUT"
    exit 1
  fi
done
# mount the disk
# you may add other mount options here, 
# e.g. if you are not using a non-partition disk, or enabling compression for btrfs
# alse remember to change the pationtion type parameter if yours is not btrfs
mount -t btrfs $device_path $mount_point
# chagne the mount point owner to you
chown artiga:artiga $mount_point
