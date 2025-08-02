#!/bin/bash
check=100

set -e
# Visual Studio Code installer for Linux

### This shell commands to install VSCode are taken from: 
# https://code.visualstudio.com/docs/setup/linux
###

# function to check if a command exists
function check_cmd(){
    if ! [ `command -v $1`  >/dev/null 2>&1 ]; then
        echo "Sorry, '$1' package required, install it with your system's package manager"
        exit 1
    fi
}

function check(){
#   before doing any checks, make sure that these three packages are installed: curl, sed, wget
    check_cmd wget
    check_cmd curl
    check_cmd sed

    remote_check="https://raw.githubusercontent.com/IDE-installers/vscode-linux-installer/main/vscode-installer.sh"

#   check internet connection
    wget -q --spider http://google.com # <-- can use another server too

    if [ $? -ne 0 ]; then
        echo "Sorry, looks like you're offline, check your internet connection"
        exit 1
    fi

#   Check if there is a new script release available
#   fetch the second line
    check_line=$(curl -sfL "$remote_check" | sed -n '2p')
    if [ -z "$check_line" ]; then
        echo "Something went wrong" >&2
        exit 1
    fi
#   and see if a new version is available
    if [[ $check_line =~ check=\"?([0-9]+)\"? ]]; then
        remote_check="${BASH_REMATCH[1]}"
    else
        echo "Unable to parse remote check from: $check_line" >&2
        exit 1
    fi

    if [[ remote_check -gt check ]]; then
        echo "A newer version of installer is available: $remote_check (currently using: $check)"
        echo "It's recommended to use the latest version scince this one has a chance of not working properly anymore"
        echo -e "Download latest version with:\nwget -N https://raw.githubusercontent.com/ide-installers/vscode-linux-installer/main/vscode-installer.sh"
    exit
    
    else
        echo -e "Up to date"
    fi
}

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
check
configure
install
