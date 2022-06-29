#!/bin env sh

USER=arch

arch-chroot -u $USER /mnt "bash -c 'systemctl --user enable pipewire-pulse.service'"
