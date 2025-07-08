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
            sudo apt-get install wget gpg
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
            rm -f packages.microsoft.gpg

            sudo apt install apt-transport-https
            sudo apt update
            sudo apt install code # or code-insiders
            ;;

        dnf)
#           stable 64-bit VS Code for RHEL, Fedora, or CentOS
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

            dnf check-update
            sudo dnf install code # or code-insiders

            ;;

        yum)
#           stable 64-bit VS Code for RHEL, Fedora, or CentOS
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

            yum check-update
            sudo yum install code # or code-insiders
            ;;

        zypper)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" |sudo tee /etc/zypp/repos.d/vscode.repo > /dev/null

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
