#!/bin/bash
BRANCH=-340xx # Enter a branch if needed, i.e. -340xx or -304xx
NVIDIA=nvidia${BRANCH} # If no branch entered above this would be "nvidia"
NOUVEAU=xf86-video-nouveau

# Replace -R with -Rs to if you want to remove the unneeded dependencies
if [ $(pacman -Qqs ^mesa-libgl$) ]; then
    sudo pacman -S ${NVIDIA}-libgl lib32-${NVIDIA}-libgl
    sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.nouveau
    sudo mv /etc/X11/xorg.conf.nvidia /etc/X11/xorg.conf
    sudo sed -i '/^#.*nvidia/s/^#//' /usr/lib/modprobe.d/nouveau.conf # disable nvidia blacklisting
    sudo sed -i -e '/nouveau/ s/^#*/#/' /usr/lib/modprobe.d/nvidia.conf # enable nouveau blacklisting
    sudo sed -i -e '/nouveau/ s/^#*/#/' /usr/lib/modprobe.d/nvidia-340xx-ck.conf # enable nouveau blacklisting for -ck drivers
elif [ $(pacman -Qqs ^${NVIDIA}$) ]; then
    sudo pacman -S --needed $NOUVEAU mesa-libgl lib32-mesa-libgl
    sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.nvidia
    sudo mv /etc/X11/xorg.conf.nouveau /etc/X11/xorg.conf
    sudo sed -i -e '/nvidia/ s/^#*/#/' /usr/lib/modprobe.d/nouveau.conf # enable nvidia blacklisting
    sudo sed -i '/^#.*nouveau/s/^#//' /usr/lib/modprobe.d/nvidia.conf # disable nouveau blacklisting
    sudo sed -i '/^#.*nouveau/s/^#//' /usr/lib/modprobe.d/nvidia-340xx-ck.conf # disable nouveau blacklisting for -ck drivers
fi
