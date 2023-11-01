# !/usr/bin/env bash


# ================================================================== #
# Autor       :   Matheus Barbosa <mdpb.matheus@gmail.com>.          #
# Licença     :   MIT                                                #
# Descrição   :   Script de automação para o sistema Fedora.         #
# Referências :   Baseado na organização de código do Jefferson      #
#                 'slackjeff' Rocha <root@slackjeff.com.br>.         #
# ================================================================== #


# ================================================================== #
#                 ALTERANDO CONFIGURAÇÕES DO SISTEMA                 #
# ================================================================== #

gsettings set org.gnome.desktop.interface enable-hot-corners false

gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'

gsettings set org.gnome.desktop.interface text-scaling-factor 0.90

gsettings set org.gnome.desktop.interface clock-show-date false

gsettings set org.gnome.desktop.interface clock-show-weekday false

gsettings set org.gnome.desktop.interface clock-format '24h'

gsettings set org.gnome.desktop.interface color-scheme 'default'

gsettings set org.gnome.desktop.interface font-hinting 'none'

gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'system'

gsettings set org.gnome.Terminal.Legacy.Profile:/barbomat/ use-system-font true

gsettings set org.gnome.desktop.sound event-sounds false

gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

gsettings set org.gnome.desktop.notifications show-in-lock-screen false

gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true

gsettings set org.gnome.desktop.peripherals.touchpad speed 0.53383458646616533

gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag true

gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true

gsettings set org.gnome.desktop.privacy remember-recent-files false

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>Left']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Right']"

cp ~/Downloads/Linux-Auto-Install/Fonts/* ~/.local/share/fonts

cp ~/Downloads/Linux-Auto-Install/Wallpapers/* ~/.local/share/backgrounds

fc-cache -f -v

gsettings set org.gnome.desktop.interface font-name 'Inter Medium 12'

gsettings set org.gnome.desktop.interface document-font-name 'Inter Medium 12'

gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Inter Bold 12'

gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono Slashed Regular 14'

gsettings set org.gnome.desktop.background picture-uri file:///home/barbomat/.local/share/backgrounds/Windows-11_Desktop_Light.jpg

gsettings set org.gnome.desktop.background picture-uri-dark file:///home/barbomat/.local/share/backgrounds/Windows-11_Desktop_Dark.jpg

printf "\n\nRealizou todas as configurações de sistema com sucesso."
printf "\n\n"


# ================================================================== #
#                         ACELERANDO O DNF                           #
# ================================================================== #

sudo sed -i 's/max_parallel_downloads=3/max_parallel_downloads=20/g' /etc/dnf/dnf.conf


# ================================================================== #
#                ATUALIZANDO E LIMPANDO O SISTEMA                    #
# ================================================================== #

sudo dnf update -y
printf "\n\n"

sudo dnf autoremove -y
printf "\n\n"

flatpak update -y
printf "\n\n"


# ================================================================== #
#                     ADICIONANDO REPOSITÓRIOS                       #
# ================================================================== #

sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
printf "\n\n"

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
printf "\n\n"

sudo dnf install gstreamer1-plugins-{bad-*,good-*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
printf "\n\n"

sudo dnf install lame* --exclude=lame-devel -y
printf "\n\n"

sudo dnf group upgrade --with-optional Multimedia -y
printf "\n\n"


# ================================================================== #
#                             VARIÁVEIS                              #
# ================================================================== #

Programas_Remover_RPM=(
    gnome-contacts
    gnome-weather
    gnome-clocks
    gnome-maps
    gnome-photos
    gnome-connections
    gnome-calculator
    gnome-console
    gnome-disk-utility
    gnome-system-monitor
    gnome-boxes
    gparted
    gnome-web
    evince
    gnome-characters
    yelp
    cheese
    gnome-font-viewer
    libreoffice-core
    gnome-abrt
    rhythmbox
    gnome-tour
    simple-scan
    gnome-music
    gnome-calendar
    gnome-text-editor
    gnome-logs
    baobab
    totem
    eog
    epiphany
    evolution
    gedit
    mediawriter
    gnome-software
    abattis-cantarell-fonts
    abattis-cantarell-vf-fonts
    liberation-serif-fonts
)

Programas_Instalar_RPM=(
    gnome-terminal
    firefox
    codium
    google-roboto-mono-fonts
)


# ================================================================== #
#                       REMOVENDO PROGRAMAS                          #
# ================================================================== #

for nome_do_programa in ${Programas_Remover_RPM[@]}; do
    if dnf list --installed | grep -q $nome_do_programa; then
    	sudo dnf autoremove $nome_do_programa -y
    	printf "\n\n"
    else
        echo "O programa $nome_do_programa não está instalado."
        printf "\n\n"
    fi
done


# ================================================================== #
#                       INSTALANDO PROGRAMAS                         #
# ================================================================== #

for nome_do_programa in ${Programas_Instalar_RPM[@]}; do
    if ! dnf list --installed | grep -q $nome_do_programa; then
        sudo dnf install $nome_do_programa -y
        printf "\n\n"
    else
        echo "O programa $nome_do_programa já está instalado."
        printf "\n\n"
    fi
done


# ================================================================== #
#                          PÓS INSTALAÇÃO                            #
# ================================================================== #

sudo dnf update -y
printf "\n\n"

sudo dnf autoremove -y
printf "\n\n"

flatpak update -y
printf "\n\n"

flatpak remove --unused -y
printf "\n\n"

