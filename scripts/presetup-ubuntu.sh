#!/usr/bash

DOCKER_VERSION=1.12.1
DOCKER_COMPOSE_VERSION=1.8.0

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

echo-red () { echo -e "${red}$1${NC}"; }
echo-green () { echo -e "${green}$1${NC}"; }
echo-yellow () { echo -e "${yellow}$1${NC}"; }

B2D_BRANCH="${B2D_BRANCH:-master}"
B2D_INSTALL_MODE="${B2D_INSTALL_MODE:-full}"

# VirtualBox and Vagrant dependencies
if [[ "$B2D_INSTALL_MODE" == "full" ]] || [[ "$B2D_INSTALL_MODE" == "vm" ]] ; then

    INSTALLED="$(which virtualbox | grep -c virtualbox)"
    sudo apt-get update
    if [ ${INSTALLED} -eq 0 ]; then
        echo "Installing virtualbox"
        sudo apt-get install -y \
            virtualbox \
            virtualbox-dkms \
            virtualbox-guest-additions-iso
    fi

    INSTALLED="$(which vagrant | grep -c vagrant)"

    if [ ${INSTALLED} -eq 0 ]; then
        echo "Installing vagrant"
        sudo apt-get install -y vagrant
    fi


    echo "Installing vagrant plugins"
    for PLUGIN in "vagrant-vbguest" "vagrant-vbox-snapshot"; do
        vagrant plugin install "${PLUGIN}"
    done
fi


