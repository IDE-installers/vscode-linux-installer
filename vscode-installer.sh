#!/bin/bash
set -e
# Visual Studio Code installer for Linux

### This shell commands to install VSCode are taken from: 
# https://code.visualstudio.com/docs/setup/linux
# https://linuxhint.com/install_visual_studio_code_arch_linux/
###

# check what package manager user uses
function configure(){

    if [ -f /bin/snap ]; then
        PM=snap # [P]ackage[M]anager

    elif [ -f /bin/apt ]; then
        PM=apt

    elif [ -f /bin/pacman ]; then
        PM=pacman

    elif [ -f /bin/dnf ]; then
        PM=dnf

    elif [ -f /bin/yum ]; then
        PM=yum

    elif [ -f /bin/zypp ]; then
        PM=zypper

    elif [ -f /bin/nix ]; then
        PM=nix

    else 
        echo "Sorry, I don't know what to do"
        exit 1
    fi

}

# function to begin the installation
function install(){
    printf "\nInstalling VSCode...\n"
    set -e

    case $PM in

        snap )
            sudo snap install --classic code # or code-insiders
            ;;

        apt)
            sudo apt-get install wget gpg
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            rm -f packages.microsoft.gpg
            sudo apt install apt-transport-https -y
            sudo apt update
            sudo apt install code -y
            ;;

        dnf)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo dnf check-update
            sudo dnf install code -y
            ;;

        yum)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo yum check-update
            sudo yum install code -y
            ;;

        zypper)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
            sudo zypper refresh
            sudo zypper install code
            ;;

        pacman)
#           Check if git is installed
            ! [[ `command -v git` ]] && sudo pacman -S git --noconfirm
            git clone https://AUR.archlinux.org/visual-studio-code-bin.git
            cd visual-studio-code-bin/
            makepkg -s
            sudo pacman -U visual-studio-code-bin-*.pkg.tar.xz
            cd ../ && sudo rm -rf visual-studio-code-bin/
            ;;

        nix)
            nix-env -i vscode
            ;;

    esac
}

printf "Visual Studio Code installer for Linux\n"
configure
install
