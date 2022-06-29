#!/bin env sh

USER=arch

arch-chroot /mnt su $USER "systemctl --user enable pipewire-pulse.service"
