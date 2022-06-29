#!/bin env sh

USER=arch

arch-chroot /mnt su $USER | arch-chroot /mnt systemctl --user enable pipewire-pulse.service
