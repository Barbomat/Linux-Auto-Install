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

sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak remote-add appcenter --if-not-exists https://flatpak.elementary.io/repo.flatpakrepo

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
)

Programas_Instalar_RPM=(
    gnome-terminal
    firefox
    speedtest-cli
    nano
    gtranslator
    codium
    rsms-inter-fonts
    jetbrains-mono-nl-fonts
    gnome-tweaks
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

cp ~/Downloads/Linux-Auto-Install/JetBrains_Mono_Slashed.otf ~/.local/share/fonts

sudo dnf update -y
printf "\n\n"

sudo dnf autoremove -y
printf "\n\n"

flatpak update -y
printf "\n\n"

flatpak remove --unused -y
printf "\n\n"


# ================================================================== #
#                           O QUE FALTA                              #
# ================================================================== #

echo "A se Fazer:  Ir no Gnome Tweaks, mudar as fontes e reduzir a escala da tela para 0,90."
echo "A se Fazer:  Ir no Google Drive e baixar o meu wallpaper pessoal."
printf "\n\n"

