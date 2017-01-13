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


# Docker and other dependencies
if [[ "$B2D_INSTALL_MODE" == "full" ]] || [[ "$B2D_INSTALL_MODE" == "docker" ]] ; then
	# Remove old docker version
	sudo rm -f /usr/local/bin/docker >/dev/null 2>&1 || true
	# Install docker
	echo-green "Installing docker cli v${DOCKER_VERSION}..."
    
    echo "[docker] Installing tools for apt repository management"
    sudo apt-get update
    sudo apt-get install apt-transport-https ca-certificates

    echo "[docker] Add net GPG key"
    sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

    echo "[docker] Add docker apt repository"
    echo "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -cs) main" | tee /etc/apt/sources.list.d/docker.list

    echo "[docker] Installing docker !"
    sudo apt-get update
    sudo apt-get install docker-engine
    sudo service docker start

    echo "[docker] Installing docker-compose"
    if [ ! -e /usr/local/bin/docker-compose ]; then
        sudo curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
fi


