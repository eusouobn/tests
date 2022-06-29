#!/bin env sh

USER=arch

arch-chroot /mnt su user -c | arch-chroot /mnt systemctl --user enable pipewire-pulse.service
