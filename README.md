# About

This bash script installs the latest VSCode version.

It contains shell commands to install VSCode from:
- [here](https://code.visualstudio.com/docs/setup/linux)
- [and here](https://linuxhint.com/install_visual_studio_code_arch_linux/)

This script should work on **most of** Linux distributions.

It supports the following package managers: **apt**, **dnf**, **zypper**, **snap**, **pacman**, **yum**, **nix**

# Note
***Sometimes the commands to install VScode can be changed by the Devs, so at some point my script will become outdated.*** 

***And scince I don't monitor the commands (from the official site) that often, I would recommend first checking them, and after that only running my scripts.***

***I will eventually check and if needed, edit (update) my scripts.***

***My scripts just contain this official commands, plus a bunch of if's, functions and a switch case to make it all function correctly***

# Usage
```
sudo bash vscode-installer.sh
```
or just
```
bash vscode-installer.sh
```
After executing this script, maybe you'll have to confirm the installation and enter sudo password (If didn't enter it before).

# Note
If VSCode is installing very slowly using this script, then try just installing it from it's [official website](https://code.visualstudio.com), from [here](https://code.visualstudio.com/Download) or from [here](https://linuxhint.com/install_visual_studio_code_arch_linux/), if you use Arch Linux.
