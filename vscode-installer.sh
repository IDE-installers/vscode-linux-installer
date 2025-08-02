#!/bin/bash
set -e
# Visual Studio Code installer for Linux

### This shell commands to install VSCode are taken from: 
# https://code.visualstudio.com/docs/setup/linux
###

# check what package manager user uses
function configure(){

    if [ -f /bin/snap ]; then
        PM=snap # [P]ackage[M]anager

    elif [ -f /bin/apt ]; then
        PM=apt

    elif [ -f /bin/dnf ]; then
        PM=dnf

    elif [ -f /bin/yum ]; then
        PM=yum

    elif [ -f /bin/zypp ]; then
        PM=zypper

    elif [ -f /bin/nix ]; then
        PM=nix

    else 
        echo "Sorry, your distribution isn't supported"
        exit 1
    fi
}

# function to begin the installation
function install(){
    printf "\nInstalling VSCode...\n"
    set -e

    case $PM in

        apt)
            sudo apt-get install wget gpg -y
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
            sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
            rm -f microsoft.gpg

            sudo echo "Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg" > /etc/apt/sources.list.d/vscode.sources

            sudo apt install apt-transport-https -y
            sudo apt update
            sudo apt install code -y # or code-insiders
            ;;

        dnf)
#           Stable 64-bit VS Code for RHEL, Fedora, or CentOS (Stream)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null


            dnf check-update
            sudo dnf install code -y # or code-insiders


            ;;
#           You can manually download and install the VS Code .rpm package (64-bit)
#           however, auto-updating won't work unless the repository above is installed
        yum)
#           For older versions using YUM
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null


            yum check-update
            sudo yum install code -y # or code-insiders
            ;;

        zypper)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" |sudo tee /etc/zypp/repos.d/vscode.repo > /dev/null

#            User will have to confirm with "Y"
            sudo zypper install code
            ;;

        nix)
            nix-env -i vscode
            ;;

        snap)
            sudo snap install --classic code # or code-insiders
            ;;
    esac
}

printf "Visual Studio Code installer for Linux\n"
configure
install
