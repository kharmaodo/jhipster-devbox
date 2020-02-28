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
# install Java 11 and another old versions
apt-get -y install openjdk-11-jdk

# install Node.js
wget https://nodejs.org/dist/v12.16.0/node-v12.16.0-linux-x64.tar.gz -O /tmp/node.tar.gz
tar -C /usr/local --strip-components 1 -xzf /tmp/node.tar.gz

# update NPM
npm install -g npm

# install Yarn
npm install -g yarn
su -c "yarn config set prefix /home/vagrant/.yarn-global" vagrant

################################################################################
# Install the graphical environment
################################################################################

# force encoding
#echo 'LANG=en_US.UTF-8' >> /etc/environment
#echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment
#echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
#echo 'LC_CTYPE=en_US.UTF-8' >> /etc/environment

# set to UTF8 locale for later powerline 
sudo update-locale LANG=en_US.uft8 LC_ALL=en_US.utf8

# run GUI as non-privileged user
echo 'allowed_users=anybody' > /etc/X11/Xwrapper.config

# install Ubuntu desktop and VirtualBox guest tools
apt-get install -y xubuntu-desktop virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# remove light-locker (see https://github.com/jhipster/jhipster-devbox/issues/54)
apt-get remove -y light-locker --purge

# Do not change the default wallpaper 
# Customize with our own
#wget https://jhipster.github.io/images/wallpaper-004-2560x1440.png -O /usr/share/xfce4/backdrops/jhipster-wallpaper.png
#wget https://raw.githubusercontent.com/jhipster/jhipster-devbox/master/images/jhipster-wallpaper.png -O /usr/share/xfce4/backdrops/jhipster-wallpaper.png
#sed -i -e 's/xubuntu-wallpaper.png/jhipster-wallpaper.png/' /etc/xdg/xdg-xubuntu/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

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
echo "Install  SDK for JVM microservice like quarkus,micronaut,thorntail"
echo "Install  Sonar"
echo "Install  Eureka"
echo "Install  Kibana"


echo "Install  RabbitMQ"

echo "Install  ActiveMQ"
cd /opt
if [ ! -f apache-activemq-5.15.8-bin.tar.gz]
then
  echo Downloading ActiveMQ...
  wget http://archive.apache.org/dist/activemq/5.15.8/apache-activemq-5.15.8-bin.tar.gz
tar -xvzf apache-activemq-5.15.8-bin.tar.gz
sudo mv apache-activemq-5.15.8 /opt/activemq
sudo addgroup --quiet --system activemq
sudo adduser --quiet --system --ingroup activemq --no-create-home --disabled-password activemq
sudo chown -R activemq:activemq /opt/activemq

fi

touch activemq.service

cat <<ActiveMQSERVICE | sudo tee activemq.service
[Unit]
Description=Apache ActiveMQ
After=network.target

[Service]
Type=forking

User=activemq
Group=activemq

ExecStart=/opt/activemq/bin/activemq start
ExecStop=/opt/activemq/bin/activemq stop

[Install]
ActiveMQSERVICE

sudo cp activemq.service /etc/systemd/system/activemq.service
sudo systemctl daemon-reload
sudo systemctl start activemq
sudo systemctl enable activemq

sh /opt/activemq/bin/activemq status

sudo systemctl restart activemq
ps aux | grep activemq

netstat -naptu | grep 61616
 echo Downloading ActiveMQ...

echo "To be done for Monitor ActiveMQ With Hawt.io"

echo "Install  Gitlab"
echo "Install  Graphana"

echo "Install  Wildfly"
echo "Install  Prometheus"
echo "Install  Gitlab"
echo "Install  Graphana"	

