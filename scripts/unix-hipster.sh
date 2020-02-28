#!/bin/sh

# switch to French keyboard layout
sudo sed -i 's/"us"/"fr"/g' /etc/default/keyboard

# sudo setxkbmap fr

sudo loadkeys fr

# update the system
export DEBIAN_FRONTEND=noninteractive
apt-mark hold keyboard-configuration
apt-get update
apt-get -y upgrade
apt-mark unhold keyboard-configuration

################################################################################
# Install the mandatory tools
################################################################################

# install utilities
#apt-get -y install vim git zip bzip2 fontconfig curl language-pack-en

apt-get -y install vim git zip bzip2 fontconfig curl  language-pack-fr
################################################################################
# Install the graphical environment
################################################################################

# force encoding
# set to UTF8 locale for later powerline 
sudo update-locale LANG=en_US.uft8 LC_ALL=en_US.utf8

# run GUI as non-privileged user
echo 'allowed_users=anybody' > /etc/X11/Xwrapper.config

# install Ubuntu desktop and VirtualBox guest tools
apt-get install -y xubuntu-desktop virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# remove light-locker (see https://github.com/jhipster/jhipster-devbox/issues/54)
apt-get remove -y light-locker --purge

# Do not change the default wallpaper 

################################################################################
# Install the development tools
################################################################################

# install Ubuntu Make - see https://wiki.ubuntu.com/ubuntu-make
apt-get install -y ubuntu-make

# install Chromium Browser
apt-get install -y chromium-browser




# install Guake
apt-get install -y guake
cp /usr/share/applications/guake.desktop /etc/xdg/autostart/

apt-get install -y zsh

# install oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
chsh -s /bin/zsh vagrant
echo 'SHELL=/bin/zsh' >> /etc/environment



# increase Inotify limit (see https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit)
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-inotify.conf
sysctl -p --system

# install latest Docker
curl -sL https://get.docker.io/ | sh

# install latest docker-compose
curl -L "$(curl -s https://api.github.com/repos/docker/compose/releases | grep browser_download_url | head -n 4 | grep Linux | grep -v sha256 | cut -d '"' -f 4)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# configure docker group (docker commands can be launched without sudo)
usermod -aG docker vagrant

# fix ownership of home
chown -R vagrant:vagrant /home/vagrant/

# clean the box
apt-get -y autoclean
apt-get -y clean
apt-get -y autoremove
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1
rm -f /EMPTY
echo "Install GCC or C Language"
sudo apt install gcc gcc-8 g++-8
echo "Install  Bison "
yes | sudo apt-get update -y
yes | sudo apt-get install -y bison
echo "Install  Lex  "
sudo apt-get update
sudo apt-get install flex
echo "Install  Latex "
sudo add-apt-repository ppa:jonathonf/texlive
sudo apt update 
sudo apt purge libkpathsea6
yes | sudo apt install -y --force-yes texlive-full
yes | sudo apt-get install -y --force-yes texlive-latex-extra
sudo apt update 

yes | apt-get -y --force-yes install texworks

echo "Install  Tcl/Tk "

sudo apt-get update
sudo apt-get install tcl

sudo apt-get update
sudo apt-get install tk

echo "Install Groff"
sudo apt-get install -y groff


