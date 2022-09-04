#!/usr/bin/env sh

printf '\x1bc';

read -p "Digite o Nome de Usuário : " USERNAME

arch-chroot /mnt /bin/bash -c "su - $USERNAME systemctl --user enable pipewire.service"
