#!/bin env sh

USER=arch

arch-chroot -u $USER /mnt systemctl --user enable pipewire-pulse.service
