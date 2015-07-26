cur_date=$(date +"%y%m%d")
#tar cf - /home/azure/. --exclude-ignore-recursive=exclude-list.txt | 7za a -mx -mmt=4 -si /mnt/winproj/Backup/arch-azure-backup-$cur_date.tar.7z
tar cf - * .* --exclude-from=exclude-list.txt | 7za a -mx -mmt=4 -si /run/media/azure/Archive\ 2/\!Ivan_Data/home.tar.7z
#tar -cf /run/media/azure/Archive\ 2/\!Ivan_Data/home.tar --exclude-from=exclude-list.txt * .*