# Visual Studio Code installer for Linux

### This shell commands to install VSCode are taken from: 
# https://code.visualstudio.com/docs/setup/linux
# https://linuxhint.com/install_visual_studio_code_arch_linux/
###

# function to configure the installer
function configure(){
    printf "Visual Studio Code installer for Linux\n"
    
    # list of valid options
    LPM=("snap" "apt" "pacman" "yum" "dnf" "zypper" "nix") # [L]ist of [P]ackage [M]anagers 

    printf "\nWhich package manager are you using?\n"
    for eachPM in "${LPM[@]}"; do echo $eachPM; done
    echo

    read PM # [P]ackage [M]anager

}

# function to begin the instalation
function install(){
    printf "Installing VSCode..."

    case $PM in

        SNAP | snap )
            set -e
            sudo snap install --classic code # or code-insiders
            ;;

        APT | apt)
            set -e
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
            sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            rm -f packages.microsoft.gpg
            sudo apt install apt-transport-https
            sudo apt update
            sudo apt install code # or code-insiders
            ;;

        DNF | dnf)
            set -e
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo dnf check-update
            sudo dnf install code
            ;;

        YUM | yum)
            set -e
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo yum check-update
            sudo yum install code
            ;;

        ZYPPER | zypper)
            set -e
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
            sudo zypper refresh
            sudo zypper install code
            ;;

        PACMAN | pacman)
            set -e
            git clone https://aur.archlinux.org/visual-studio-code-bin.git
            cd visual-studio-code-bin/
            echo "Y" | makepkg -s # ' echo "Y" | ' is to automatically say 'yes', to confirm the instalation
            echo "Y" | sudo pacman -U visual-studio-code-bin-*.pkg.tar.xz
            cd ../ && sudo rm -rf visual-studio-code-bin/
            ;;

        NIX | nix)
            set -e
            nix-env -i vscode
            ;;

        *) echo "${PM} is invalid choice!";exit 1;;
    esac
}

configure
install
