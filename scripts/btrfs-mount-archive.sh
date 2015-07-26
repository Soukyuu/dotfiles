sudo cryptsetup open $1 archive
sudo mount -t btrfs -o noatime,autodefrag /dev/mapper/archive /mnt/btrfs-root
