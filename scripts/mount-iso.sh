if [ -z $2 ]
  then
    sudo mount -t iso9660 -o loop "$1" /mnt/iso
  else
    sudo mount -t udf -o loop "$1" /mnt/iso
fi

