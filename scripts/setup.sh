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

# install MySQL Workbench
apt-get install -y mysql-workbench

# install PgAdmin
apt-get install -y pgadmin3

# install Heroku toolbelt
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# install Guake
apt-get install -y guake
cp /usr/share/applications/guake.desktop /etc/xdg/autostart/

# install jhipster-devbox
#git clone git://github.com/jhipster/jhipster-devbox.git /home/vagrant/jhipster-devbox
#chmod +x /home/vagrant/jhipster-devbox/tools/*.sh

# install zsh
apt-get install -y zsh

# install oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
chsh -s /bin/zsh vagrant
echo 'SHELL=/bin/zsh' >> /etc/environment

# install jhipster-oh-my-zsh-plugin
#git clone https://github.com/jhipster/jhipster-oh-my-zsh-plugin.git /home/vagrant/.oh-my-zsh/custom/plugins/jhipster
#sed -i -e "s/plugins=(git)/plugins=(git docker docker-compose jhipster)/g" /home/vagrant/.zshrc
#echo 'export PATH="$PATH:/usr/bin:/home/vagrant/.yarn-global/bin:/home/vagrant/.yarn/bin:/home/vagrant/.config/yarn/global/node_modules/.bin"' >> /home/vagrant/.zshrc

# change user to vagrant
#chown -R vagrant:vagrant /home/vagrant/.zshrc /home/vagrant/.oh-my-zsh

# install Visual Studio Code
su -c 'umake ide visual-studio-code /home/vagrant/.local/share/umake/ide/visual-studio-code --accept-license' vagrant

# fix links (see https://github.com/ubuntu/ubuntu-make/issues/343)
sed -i -e 's/visual-studio-code\/code/visual-studio-code\/bin\/code/' /home/vagrant/.local/share/applications/visual-studio-code.desktop

# disable GPU (see https://code.visualstudio.com/docs/supporting/faq#_vs-code-main-window-is-blank)
sed -i -e 's/"$CLI" "$@"/"$CLI" "--disable-gpu" "$@"/' /home/vagrant/.local/share/umake/ide/visual-studio-code/bin/code

#install IDEA community edition
su -c 'umake ide idea /home/vagrant/.local/share/umake/ide/idea' vagrant

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

# install Eclipse Kepler 4.3.1 Java EE 
echo "Install  Eclipse"

if [ ! -d /vagrant/resources ]
then
  mkdir -p /vagrant/resources
fi


if [ ! -f /vagrant/resources/eclipse-jee-2019-12-R-linux-gtk-x86_64.tar.gz ]
then
  cd /vagrant/resources
  pwd 
  echo Downloading Eclipse...
   wget -q https://eclipse.bluemix.net/packages/2019-12/data/eclipse-jee-2019-12-R-linux-gtk-x86_64.tar.gz
  cd /home/vagrant
fi


sudo tar xzf /vagrant/resources/eclipse-jee-2019-12-R-linux-gtk-x86_64.tar.gz -C /opt --owner=root

cat <<DESKTOP | sudo tee /usr/share/applications/eclipse.desktop
[Desktop Entry]
Version=4.3.1
Name=Eclipse for Java EE Developers
Comment=IDE for all seasons
Exec=env UBUNTU_MENUPROXY=0 /opt/eclipse/eclipse
Icon=/opt/eclipse/icon.xpm
Terminal=false
Type=Application
Categories=Utility;Application;Development;IDE
DESKTOP


mkdir -p /home/vagrant/workspace
chown -R vagrant:vagrant /home/vagrant/workspace

if [ ! -f mkdir -p /home/vagrant/.eclipse/org.eclipse.platform_4.3.0_1473617060_linux_gtk_x86_64/configuration/.settings/ ]
then

	mkdir -p /home/vagrant/.eclipse/org.eclipse.platform_4.3.0_1473617060_linux_gtk_x86_64/configuration/.settings/
fi	

chown -R vagrant:vagrant  /home/vagrant/.eclipse/org.eclipse.platform_4.3.0_1473617060_linux_gtk_x86_64/configuration/.settings/
chown -R vagrant:vagrant  /home/vagrant/.eclipse/org.eclipse.platform_4.3.0_1473617060_linux_gtk_x86_64/configuration/.settings/org.eclipse.ui.ide.prefs
cat <<PREFS | tee /home/vagrant/.eclipse/org.eclipse.platform_4.3.0_1473617060_linux_gtk_x86_64/configuration/.settings/org.eclipse.ui.ide.prefs 
MAX_RECENT_WORKSPACES=5
RECENT_WORKSPACES=/home/vagrant/workspace
RECENT_WORKSPACES_PROTOCOL=3
SHOW_WORKSPACE_SELECTION_DIALOG=false
eclipse.preferences.version=1
PREFS


echo "Install  SDK for JVM microservice like quarkus,micronaut,thorntail"
echo "Install  Nginx "
echo "Pull latest Nginx"
sudo docker pull nginx
echo "......;"

echo "Redirection of 8080 to 80 latest Nginx"
sudo docker run –p 8080:80 –d nginx
echo "......;"


echo "Install  Sonar"
echo "Install  CouchDB"

echo "deb https://apache.bintray.com/couchdb-deb bionic main" | sudo tee -a /etc/apt/sources.list



curl -L https://couchdb.apache.org/repo/bintray-pubkey.asc | sudo apt-key add -
sudo apt-get update -y && sudo apt-get install couchdb -y 

sudo systemctl start couchdb
sudo systemctl enable couchdb

sudo systemctl status couchdb


echo "... end of installing couchDB"
echo "Install  Eureka"


echo "Install  Elasticsearch"
echo "Install  Logstash"
echo "Install  Kibana"

echo "Install  Kafka"
wget http://www-us.apache.org/dist/kafka/2.2.1/kafka_2.12-2.2.1.tgz
sudo tar xzf kafka_2.12-2.2.1.tgz
sudo mv kafka_2.12-2.2.1 /usr/local/kafka

cd /usr/local/kafka
sh bin/zookeeper-server-start.sh config/zookeeper.properties &


echo "... end of kafka"





echo "Install  RabbitMQ"
echo "Install  ActiveMQ"
echo "Install  Gitlab"
echo "Install  Graphana"

echo "Install  Wildfly"
echo "Install  Prometheus"
echo "Install  Gitlab"
echo "Install  Graphana"	

echo "Install Solr"
cd /opt
wget https://archive.apache.org/dist/lucene/solr/8.3.1/solr-8.3.1.tgz && tar xzf solr-8.3.1.tgz solr-8.3.1/bin/install_solr_service.sh --strip-components=2

sudo bash ./install_solr_service.sh solr-8.3.1.tgz

sudo service solr stop
sudo service solr start
sudo service solr status

echo ".... end  of installing Solr"



