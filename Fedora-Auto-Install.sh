# !/usr/bin/env bash


# ================================================================== #
# Autor       :   Matheus Barbosa <mdpb.matheus@gmail.com>.          #
# Licença     :   MIT                                                #
# Descrição   :   Script de automação para o sistema Fedora.         #
# Referências :   Baseado na organização de código do Jefferson      #
#                 'slackjeff' Rocha <root@slackjeff.com.br>.         #
# ================================================================== #


# ================================================================== #
#                         ACELERANDO O DNF                           #
# ================================================================== #

sudo sed -i 's/max_parallel_downloads=3/max_parallel_downloads=20/g' /etc/dnf/dnf.conf
printf "\n\n"


# ================================================================== #
#                ATUALIZANDO E LIMPANDO O SISTEMA                    #
# ================================================================== #

sudo dnf update -y
printf "\n\n"

sudo dnf autoremove -y
printf "\n\n"

flatpak update -y
printf "\n\n"

flatpak remove --unused -y
printf "\n\n"


# ================================================================== #
#                     ADICIONANDO REPOSITÓRIOS                       #
# ================================================================== #

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak remote-add appcenter --if-not-exists https://flatpak.elementary.io/repo.flatpakrepo

printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscode.repo
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
)

Programas_Instalar_RPM=(
    gnome-terminal
    firefox
    code
    rsms-inter-fonts
    rust
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
#                 ALTERANDO CONFIGURAÇÕES DO SISTEMA                 #
# ================================================================== #

cd ~/.local/share && mkdir -p fonts

cp ~/Downloads/Linux-Auto-Install/Buon-Minimalist-Wall_Desktop_Dark.jpg ~/.local/share/backgrounds

cp ~/Downloads/Linux-Auto-Install/JetBrains_Mono_Slashed.otf ~/.local/share/fonts

gsettings set org.gnome.desktop.interface text-scaling-factor 0.90

gsettings set org.gnome.desktop.background picture-uri file:///home/barbomat/.local/share/backgrounds/Buon-Minimalist-Wall_Desktop_Dark.jpg

gsettings set org.gnome.desktop.background picture-uri-dark file:///home/barbomat/.local/share/backgrounds/Buon-Minimalist-Wall_Desktop_Dark.jpg

gsettings set org.gnome.desktop.interface clock-show-date false

gsettings set org.gnome.desktop.interface clock-show-weekdate false

gsettings set org.gnome.desktop.interface clock-format '24h'

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'

gsettings set org.gnome.desktop.interface document-font-name 'Inter Regular 12'

gsettings set org.gnome.desktop.interface font-name 'Inter Regular 12'

gsettings set org.gnome.desktop.interface monospace-font-name 'Jetbrains Mono Slashed 12'

gsettings set org.gnome.desktop.interface font-alialiasing 'rgba'

gsettings set org.gnome.desktop.interface font-hinting 'full'


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

