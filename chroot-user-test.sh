#!/bin env sh

USER=arch

arch-chroot /mnt su $USER -c systemctl --user enable pipewire-pulse.service
