#!/usr/bin/env sh



### UTILITARIOS BASICOS

pacman -S dosfstools nano wget --noconfirm




###HOSTNAME

printf '\x1bc';

read -p "Digite o Hostname : " HOSTNAME




###USERNAME

printf '\x1bc';

read -p "Digite o Nome de Usuário : " USERNAME



echo -e "\n\n\n"



####SELECIONAR DISCO PARA INSTALAÇÃO


devices_list=$(lsblk -dlnp -I 2,3,8,9,22,34,56,57,58,65,66,67,68,69,70,71,72,91,128,129,130,131,132,133,134,135,259 | awk '{print $1,$4,$6,$7}' | column -t)

devices_select=$(lsblk -nd --output NAME | grep 'sd\|hd\|vd\|nvme\|mmcblk')

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e "Lista de Dispositivos:"
echo -e "\n"
echo -e "Nome - Tam. - Tipo"
echo -e "$devices_list"
echo -e "\n"
echo -e 'Escolha um Disco para Instalar o Sistema: '
select installdisk in $devices_select; do
echo "/dev/$installdisk";
break

done



### SISTEMA DE ARQUIVOS

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Sistema de Arquivos: '
select filesystem in {ext4,btrfs,f2fs,xfs};do
	case $filesystem in

	ext4)
	echo "ext4";;

	btrfs|f2fs|xfs)
	echo "${filesystem,,}";;

	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done




### HOME SEPARADA

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e "/home separada?:"
select separatehome in {SIM,NÃO};do
echo "$separatehome";
break
done


if [ "$separatehome" = "NÃO" ];then
break

else

echo "Sim"

mkdir /mnt/home

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e "Lista de Dispositivos:"
echo -e "\n"
echo -e "Nome - Tam. - Tipo"
echo -e "$devices_list"
echo -e "\n"
echo -e 'Escolha um Disco para /home: '
select homedisk in $devices_select; do
echo "/dev/$homedisk";
break

done

fi




if [ "$separatehome" = "SIM" ];then

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e "Formatar /home?:"
select formathome in {SIM,NÃO};do
echo "$formathome";
break
done


if [ "$formathome" = "NÃO" ];then
break

else

echo "Sim"

if [  $(echo $homedisk | grep -c sd) = 1 ]; then
echo "sda"

        parted /dev/${homedisk,,} mklabel gpt -s
	
        if [ "$filesystem" = "ext4" ];then
                parted /dev/${homedisk,,} mkpart primary ext4 1MiB 100% -s
                mkfs.ext4 -F /dev/${homedisk,,}1

        elif [ "$filesystem" = "btrfs" ];then
                parted /dev/${homedisk,,} mkpart primary btrfs 1MiB 100% -s
                mkfs.btrfs -f /dev/${homedisk,,}1

        elif [ "$filesystem" = "f2fs" ];then
                parted /dev/${homedisk,,} mkpart primary f2fs 1MiB 100% -s
                mkfs.f2fs -f /dev/${homedisk,,}1

        elif [ "$filesystem" = "xfs" ];then
                parted /dev/${homedisk,,} mkpart primary xfs 1MiB 100% -s
                mkfs.xfs -f /dev/${homedisk,,}1

        fi

elif [  $(echo $installdisk | grep -c nvme) = 1 ]; then
echo "NVME"

        if [ "$filesystem" = "ext4" ];then
                parted /dev/${homedisk,,} mkpart primary ext4 1MiB 100% -s
                mkfs.ext4 -F /dev/${homedisk,,}p1

        elif [ "$filesystem" = "btrfs" ];then
                parted /dev/${homedisk,,} mkpart primary btrfs 1MiB 100% -s
                mkfs.btrfs -f /dev/${homedisk,,}p1

        elif [ "$filesystem" = "f2fs" ];then
                parted /dev/${homedisk,,} mkpart primary f2fs 1MiB 100% -s
                mkfs.f2fs -f /dev/${homedisk,,}p1

        elif [ "$filesystem" = "xfs" ];then
                parted /dev/${homedisk,,} mkpart primary xfs 1MiB 100% -s
                mkfs.xfs -f /dev/${homedisk,,}p1
        fi

fi


fi


fi




###DETECTAR UEFI OU LEGACY

PASTA_EFI=/sys/firmware/efi

if [ -d "$PASTA_EFI" ];then

echo -e "Sistema EFI"

parted /dev/${installdisk,,} mklabel gpt -s
parted /dev/${installdisk,,} mkpart primary fat32 1MiB 301MiB -s
parted /dev/${installdisk,,} set 1 esp on
       if [  $(echo $installdisk | grep -c sd) = 1 ]; then
       echo "sda"
       mkfs.fat -F32 /dev/${installdisk,,}1
       elif [  $(echo $installdisk | grep -c nvme) = 1 ]; then
       echo "nvme"
       mkfs.fat -F32 /dev/${installdisk,,}p1
       fi

	   ###PARTIÇÃO ROOT
           if [  $(echo $installdisk | grep -c sd) = 1 ]; then
           echo "sda"
                      if [ "$filesystem" = "ext4" ];then
	              parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.ext4 -F /dev/${installdisk,,}2
		      mount /dev/${installdisk,,}2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}1 /mnt/boot/efi

                      elif [ "$filesystem" = "btrfs" ];then
                      parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.btrfs -f /dev/${installdisk,,}
		      mount /dev/${installdisk,,}2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}1 /mnt/boot/efi

                      elif [ "$filesystem" = "f2fs" ];then
                      parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.f2fs -f /dev/${installdisk,,}
		      mount /dev/${installdisk,,}2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}1 /mnt/boot/efi

                      elif [ "$filesystem" = "xfs" ];then
                      parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.xfs -f /dev/${installdisk,,}
		      mount /dev/${installdisk,,}2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}1 /mnt/boot/efi

                      fi

           elif [  $(echo $installdisk | grep -c nvme) = 1 ]; then
           echo "NVME"
	              if [ "$filesystem" = "ext4" ];then
	              parted /dev/${installdisk,,} mkpart primary ext4 301MiB 100% -s
                      mkfs.ext4 -F /dev/${installdisk,,}p2
		      mount /dev/${installdisk,,}p2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}p1 /mnt/boot/efi

                      elif [ "$filesystem" = "btrfs" ];then
                      parted /dev/${installdisk,,} mkpart primary btrfs 301MiB 100% -s
                      mkfs.btrfs -f /dev/${installdisk,,}p2
		      mount /dev/${installdisk,,}p2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}p1 /mnt/boot/efi

                      elif [ "$filesystem" = "f2fs" ];then
                      parted /dev/${installdisk,,} mkpart primary f2fs 301MiB 100% -s
                      mkfs.f2fs -f /dev/${installdisk,,}p2
		      mount /dev/${installdisk,,}p2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}p1 /mnt/boot/efi

                      elif [ "$filesystem" = "xfs" ];then
                      parted /dev/${installdisk,,} mkpart primary xfs 301MiB 100% -s
                      mkfs.xfs -f /dev/${installdisk,,}p2
		      mount /dev/${installdisk,,}p2 /mnt
                      mkdir /mnt/boot/
                      mkdir /mnt/boot/efi
                      mount /dev/${installdisk,,}p1 /mnt/boot/efi

                      fi

	   fi


fi



if [ ! -d "$PASTA_EFI" ];then

echo -e "Sistema Legacy"

parted /dev/${installdisk,,} mklabel msdos -s

	   ###PARTIÇÃO ROOT
           if [  $(echo $installdisk | grep -c sd) = 1 ]; then
           echo "sda"
                      if [ "$filesystem" = "ext4" ];then
	              parted /dev/${installdisk,,} mkpart primary ext4 1MiB 100% -s
                      mkfs.ext4 -F /dev/${installdisk,,}1
		      parted /dev/${installdisk,,} set 1 boot on
		      mount /dev/${installdisk,,}1 /mnt

                      elif [ "$filesystem" = "btrfs" ];then
	              parted /dev/${installdisk,,} mkpart primary ext4 1MiB 100% -s
                      mkfs.ext4 -f /dev/${installdisk,,}1
		      parted /dev/${installdisk,,} set 1 boot on
		      mount /dev/${installdisk,,}1 /mnt

                      if [ "$filesystem" = "f2fs" ];then
	              parted /dev/${installdisk,,} mkpart primary f2fs 1MiB 100% -s
                      mkfs.ext4 -f /dev/${installdisk,,}1
		      parted /dev/${installdisk,,} set 1 boot on
		      mount /dev/${installdisk,,}1 /mnt

                      elif [ "$filesystem" = "xfs" ];then
	              parted /dev/${installdisk,,} mkpart primary xfs 1MiB 100% -s
                      mkfs.ext4 -f /dev/${installdisk,,}1
		      parted /dev/${installdisk,,} set 1 boot on
		      mount /dev/${installdisk,,}1 /mnt

                      fi

           elif [  $(echo $installdisk | grep -c nvme) = 1 ]; then
           echo "NVME"
	              if [ "$filesystem" = "ext4" ];then
	              parted /dev/${installdisk,,} mkpart primary ext4 1MiB 100% -s
                      mkfs.ext4 -F /dev/${installdisk,,}p2
		      parted /dev/${installdisk,,} set 1 boot on
		      mount /dev/${installdisk,,}p1 /mnt


                      elif [ "$filesystem" = "btrfs" ];then
	              parted /dev/${installdisk,,} mkpart primary btrfs 1MiB 100% -s
                      mkfs.btrfs -f /dev/${installdisk,,}p2
		      parted /dev/${installdisk,,} set 1 boot on
		      mount /dev/${installdisk,,}p1 /mnt

                      elif [ "$filesystem" = "f2fs" ];then
	              parted /dev/${installdisk,,} mkpart primary f2fs 1MiB 100% -s
                      mkfs.btrfs -f /dev/${installdisk,,}p2
		      parted /dev/${installdisk,,} set 1 boot on
		      mount /dev/${installdisk,,}p1 /mnt

                      elif [ "$filesystem" = "xfs" ];then
	              parted /dev/${installdisk,,} mkpart primary xfs 1MiB 100% -s
                      mkfs.btrfs -f /dev/${installdisk,,}p2
		      parted /dev/${installdisk,,} set 1 boot on
		      mount /dev/${installdisk,,}p1 /mnt

                      fi

	          fi

      fi
fi





### SWAP

printf '\x1bc';

echo -e "##### SWAP #####"
echo -e "\n"
echo -e "Para Máquinas até 8GB de RAM - 4GB de SWAP"
echo -e "\n"
echo -e "Acima de 8GB de RAM - 2GB de SWAP"
echo -e "\n"
echo -e "Digite o NÚMERO correspondente a quantidade de SWAP em GB"
echo -e "\n"
echo -e "Exemplo: Para 2GB de SWAP - Digite 2"
echo -e "\n"

read -p "SWAP em GB : " SWAP




### DRIVER DE VIDEO

printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Driver de Vídeo: '
select videodriver in {AMDGPU,ATI,INTEL,Nouveau,Nvidia,VMWARE};do
	case $videodriver in
	AMDGPU|ATI|INTEL|Nouveau|Nvidia|VMWARE)
	echo -e "${videodriver,,}\nOK";;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done





### INTERFACE GRAFICA (DE)


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha uma Interface Grafica: '
select DE in {Budgie,Cinnamon,Deepin,Gnome,Plasma-X11,Plasma-Wayland,LXDE,LXQT,MATE,XFCE};do
	case $DE in
	Budgie|Cinnamon|Deepin|Gnome|Plasma-X11|Plasma-Wayland|LXDE|LXQT|MATE|XFCE)
	echo -e "${de,,}\nOK";;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done



### MONTAR /HOME

echo "Montando /home"

        if [  $(echo $homedisk | grep -c sd) = 1 ]; then
        echo "sda"
        mkdir /mnt/home
        mount /dev/${homedisk,,}1 /mnt/home

        elif [  $(echo $homedisk | grep -c nvme) = 1 ]; then
        echo "NVME"
        mkdir /mnt/home
        mount /dev/${homedisk,,}p1 /mnt/home
        fi


### KERNEL


printf '\x1bc';
PS3=$'\nSelecione uma opção: ';
echo -e 'Escolha um Kernel: '
select kernel in {linux,linux-zen,linux-lts,linux-harneded};do
	case $kernel in
	linux|linux-zen|linux-lts|linux-harneded)
	pacstrap /mnt base btrfs-progs dosfstools e2fsprogs f2fs-tools dosfstools xfsprogs linux-firmware ${kernel,,};;
	*) echo -e "\e[1;38mErro\e[m\nEscolha uma Opção válida.";continue;;
	esac
break;
done



###FSTAB

genfstab -U /mnt > /mnt/etc/fstab




###### INSIDE CHROOT




###AJUSTAR HORA AUTOMATICAMENTE

arch-chroot /mnt timedatectl set-ntp true



###SINCRONIZAR REPOSITORIOS

arch-chroot /mnt pacman -Syy git --noconfirm


###UTILITARIOS BASICOS

arch-chroot /mnt pacman -Sy nano wget pacman-contrib reflector sudo grub --noconfirm




###ADD-USER


arch-chroot /mnt useradd -m $USERNAME

echo -e "$(tput sgr0)"



### SET-HOSTNAME-AND-CONFIGURE-HOSTS

echo -e "$HOSTNAME" > /mnt/etc/hostname

echo -e "127.0.0.1 localhost.localdomain localhost\n::1 localhost.localdomain localhost\n127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" | arch-chroot /mnt tee /etc/hosts




##### INSIDE CHROOT #####



###AJUSTAR HORA AUTOMATICAMENTE

arch-chroot /mnt timedatectl set-ntp true


###FUSO HORÁRIO

arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
arch-chroot /mnt sed -i '/#NTP=/d' /etc/systemd/timesyncd.conf
arch-chroot /mnt sed -i 's/#Fallback//' /etc/systemd/timesyncd.conf
arch-chroot /mnt echo \"FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org\" >> /etc/systemd/timesyncd.conf
arch-chroot /mnt systemctl enable systemd-timesyncd.service



###SINCRONIZAR REPOSITORIOS

arch-chroot /mnt pacman -Syy git --noconfirm


###UTILITARIOS BASICOS

arch-chroot /mnt pacman -Sy nano wget pacman-contrib reflector sudo grub --noconfirm



###MIRRORS

#cp /mnt/etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist.bak && curl -s "https://archlinux.org/mirrorlist/?country=BR&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - | tee /mnt/etc/pacman.d/mirrorlist && sed -i '/br.mirror.archlinux-br.org/d' /mnt/etc/pacman.d/mirrorlist




###PARALLEL DOWNLOADS

cp /mnt/etc/pacman.conf /mnt/etc/pacman.conf.bak && sed -i '37c\ParallelDownloads = 16' /mnt/etc/pacman.conf && arch-chroot /mnt pacman -Syyyuuu --noconfirm




###MULTILIB

sed -i '93c\[multilib]' /mnt/etc/pacman.conf && sed -i '94c\Include = /etc/pacman.d/mirrorlist' /mnt/etc/pacman.conf && arch-chroot /mnt pacman -Syyyuu --noconfirm




###FUSO HORARIO

arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && arch-chroot /mnt hwclock --systohc


arch-chroot /mnt timedatectl set-timezone America/Sao_Paulo



###LOCALE

mv /mnt/etc/locale.gen /mnt/etc/locale.gen.bak && echo -e 'pt_BR.UTF-8 UTF-8' | tee /mnt/etc/locale.gen && arch-chroot /mnt locale-gen && echo -e 'LANG=pt_BR.UTF-8' | tee /mnt/etc/locale.conf




###GRUPOS

arch-chroot /mnt groupadd -r autologin

arch-chroot /mnt groupadd -r sudo

arch-chroot /mnt usermod -G autologin,sudo,wheel,lp $USERNAME




###WHEEL

cp /mnt/etc/sudoers /mnt/etc/sudoers.bak && sed -i '82c\ %wheel ALL=(ALL:ALL) ALL' /mnt/etc/sudoers




###SET-VIDEO-DRIVER

arch-chroot /mnt pacman -S xf86-video-${videodriver,,} --noconfirm



###SET-DESKTOP-ENVIRONMENT



if [ "$DE" = "Budgie" ];then

echo "Budge"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S budgie-desktop gnome-terminal gedit gnome-calculator gnome-calendar gnome-system-monitor nautilus network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "Cinnamon" ];then

echo "Cinnamon"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S cinnamon network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "Deepin" ];then

echo "Deepin"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S deepin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "Gnome" ];then

echo "Gnome"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S gnome gnome-tweaks network-manager-applet gdm --noconfirm
arch-chroot /mnt systemctl enable gdm NetworkManager

elif [ "$DE" = "Plasma-X11" ];then

echo "Plasma-X11"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager


elif [ "$DE" = "Plasma-Wayland" ];then

echo "Plasma-Wayland"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S plasma konsole sddm dolphin spectacle kcalc kwrite gwenview plasma-nm plasma-pa plasma-wayland-session --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager

elif [ "$DE" = "LXDE" ];then

echo "LXDE"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S lxde-gtk3 lxtask network-manager-applet lightdm lightdm-gtk-greeter --noconfirm
arch-chroot /mnt systemctl enable lightdm NetworkManager

elif [ "$DE" = "LXQT" ];then

echo "LXQT"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S lxqt lxtask network-manager-applet sddm --noconfirm
arch-chroot /mnt systemctl enable sddm NetworkManager

elif [ "$DE" = "MATE" ];then

echo "MATE"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S mate mate-extra network-manager-applet lightdm lightdm-gtk-greeter --noconfirm

arch-chroot /mnt systemctl enable lightdm NetworkManager



elif [ "$DE" = "XFCE" ];then

echo "XFCE"

echo -e "$(tput sgr0)\n\n"

##Pacotes Padrão

arch-chroot /mnt pacman -S xorg-server xorg-xinit xterm networkmanager tar gzip bzip2 zip unzip unrar p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-user-dirs gnome-disk-utility neofetch --noconfirm

##Interface e DM

arch-chroot /mnt pacman -S xfce4 xfce4-screenshooter xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin xarchiver lxtask ristretto mousepad galculator thunar-archive-plugin network-manager-applet lightdm lightdm-gtk-greeter --noconfirm

arch-chroot /mnt systemctl enable lightdm NetworkManager

fi


echo -e "$(tput sgr0)\n\n"




###GRUB

PASTA_EFI=/sys/firmware/efi
if [ ! -d "$PASTA_EFI" ];then
echo -e "Sistema Legacy"
arch-chroot /mnt grub-install --target=i386-pc /dev/sda --force && arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

else
echo -e "Sistema EFI"
pacman -S efibootmgr --noconfirm
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --removable && arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
fi




###USER DIRS UPDATE

arch-chroot /mnt xdg-user-dirs-update






##### USER PASSWORD

printf '\x1bc';

echo "Digite e Repita a Senha de Usuário"

arch-chroot /mnt passwd $USERNAME




##### ROOT PASSWORD

printf '\x1bc';

echo "Digite e Repita a Senha de ROOT"

arch-chroot /mnt passwd




###SET-SWAP

if [ "$filesystem" = "btrfs" ];then

arch-chroot /mnt truncate -s 0 /swapfile && arch-chroot /mnt chattr +C /swapfile && arch-chroot /mnt btrfs property set /swapfile compression "" && arch-chroot /mnt fallocate -l ${SWAP,,}G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && echo -e '/swapfile none swap defaults 0 0\n' | arch-chroot /mnt tee -a /etc/fstab

else

arch-chroot /mnt fallocate -l ${SWAP,,}G /swapfile && arch-chroot /mnt chmod 600 /swapfile && arch-chroot /mnt mkswap /swapfile && arch-chroot /mnt swapon /swapfile && echo -e '/swapfile none swap defaults 0 0\n' | arch-chroot /mnt tee -a /etc/fstab

fi



echo -e "$(tput bel)$(tput bold)$(tput setaf 7)$(tput setab 4)"


echo -e "Instalação Concluída!!!!!"


echo -e "$(tput sgr0)"
