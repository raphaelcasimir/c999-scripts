#!/usr/bin.env bash
# This is intended to run only on a freshly installed system. This will meet my needs but probably not yours.

# Licence: Do What the Fuck You Want to Public License.

if [ "$EUID" -eq 0 ]
then
	echo "Please do not this run as root"
	exit 0
fi

function getApp(){
	curl -sL https://api.github.com/repos/$1/releases/latest \
	| grep -E ".*\.AppImage\"" | grep "browser_download_url" \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| wget -i -
}

function getTxz(){
	curl -sL https://api.github.com/repos/$1/releases/latest \
	| grep -E ".*\.tar\.xz\"" | grep "browser_download_url" \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| wget -i -
	tar xvf *.tar.xz -C ~/apps
}

# For Docker
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Doesn't work on Mint, see my Mint Docker install script
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get upgrade

sudo groupadd docker
sudo usermod -aG docker $USER

sudo apt install docker-ce docker-ce-cli containerd.io

echo "Done installing Docker"
# End Docker

# Essential apps
sudo apt-get install -y git htop python3-pip spyder3 ncdu zenmap default-jre default-jdk ant build-essential

# Sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get update
sudo apt-get install sublime-merge sublime-text
echo "Done installing sublime-apps"
# End Sublime

mkdir ~/projects ~/apps

getApp "prusa3d/Slic3r"
getApp "Ultimaker/Cura"
getApp "balena-io/etcher"

mv *.AppImage ~/apps

chmod +x ~/apps/*.AppImage
echo "Done installing AppImages"


# Build and install Arduino
getTxz "arduino/Arduino"

cd Arduino*

cd build

ant dist

mkdir -p /home/$USER/.local/share/icons/hicolor/

cd linux/work/

sudo ./install.sh

sudo adduser $USER dialout

echo "Done installing Arduino"
# Done installing Arduino

# Installing personal tools
cd ~/projects

git clone https://github.com/raphaelcasimir/raphsh.git
git clone https://github.com/raphaelcasimir/elder-scrolling.git

cd raphsh

./raphsh.sh

cd ../elder-scrolling

./install_mouse_scroll.sh

# Need to log in and out, may as well reboot
read -p "Do you want to reboot now?" rboot

if [ $rboot -eq "y" ]
then
	sudo reboot
else
	echo "You will at least need to log in and out."
fi

echo -e "\nYour PC is ready to rock."
