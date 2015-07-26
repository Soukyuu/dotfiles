cur_date=$(date +"%y%m%d")
tar cf - /* --exclude={"/dev/*","/home/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found/*","/var/tmp/*","/var/lib/systemd/coredump/*","/backup/*"} | 7za a -mx -mmt=4 -si /mnt/windata/Backup/arch-backup-$cur_date.tar.7z
