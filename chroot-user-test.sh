#!/bin env sh

USER=arch

arch-chroot /mnt su user -c 'systemctl --user enable pipewire-pulse.service'
