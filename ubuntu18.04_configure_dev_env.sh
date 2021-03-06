#!/bin/bash

### Prerequisites

# Update packages list
sudo apt update || exit 1

# Install
sudo apt install -y software-properties-common curl || exit 1

curl --version || exit 1

### Git

# Install
sudo apt install -y git || exit 1

# Configure Git
git config --global user.name "$(read -r -p 'Enter your Git name: ' gitname && echo "${gitname}")" || exit 1
git config --global user.email "$(read -r -p 'Enter your Git email: ' gitemail && echo "${gitemail}")" || exit 1

git --version || exit 1
git config --list || exit 1

### Symfony CLI

# Download executable in local user folder
curl -sS https://get.symfony.com/cli/installer | bash || exit 1

# Move the executable in global bin directory in order to use it globally
sudo mv ~/.symfony/bin/symfony /usr/local/bin/symfony || exit 1

symfony -V || exit 1

### PHP 7.3

# Add PHP official repository
sudo add-apt-repository -y ppa:ondrej/php || exit 1

# Install
sudo apt install -y php7.3 || exit 1

# Install extensions
sudo apt install -y php7.3-mbstring php7.3-mysql php7.3-xml php7.3-curl php7.3-zip php7.3-intl php7.3-gd php-xdebug || exit 1

# Make a backup of the config file
phpinipath=$(php -r "echo php_ini_loaded_file();") || exit 1
sudo cp "${phpinipath}" "$(dirname "${phpinipath}")/.php.ini.backup" || exit 1

# Update some configuration in php.ini
sudo sed -i'.tmp' -e 's/post_max_size = 8M/post_max_size = 64M/g' "${phpinipath}" || exit 1
sudo sed -i'.tmp' -e 's/upload_max_filesize = 8M/upload_max_filesize = 64M/g' "${phpinipath}" || exit 1
sudo sed -i'.tmp' -e 's/memory_limit = 128M/memory_limit = -1/g' "${phpinipath}" || exit 1
sudo sed -i'.tmp' -e 's/display_errors = Off/display_errors = On/g' "${phpinipath}" || exit 1
sudo sed -i'.tmp' -e 's/display_startup_errors = Off/display_startup_errors = On/g' "${phpinipath}" || exit 1
sudo sed -i'.tmp' -e 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/g' "${phpinipath}" || exit 1

# Remove temporary file
sudo rm "${phpinipath}.tmp" || exit 1

# Replace default PHP installation in $PATH
sudo update-alternatives --set php /usr/bin/php7.3 || exit 1

php -v || exit 1
php -m || exit 1

### Composer 1.9

# Download installer
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" || exit 1

# Install
sudo php composer-setup.php --version=1.9.1 --install-dir=/usr/local/bin/ || exit 1

# Remove installer
sudo php -r "unlink('composer-setup.php');" || exit 1

# Make it executable globally
sudo mv /usr/local/bin/composer.phar /usr/local/bin/composer || exit 1

composer -V || exit 1

### MariaDB 10.4

# Add MariaDB official repository
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo -E bash || exit 1

# Install
sudo apt install -y mariadb-server-10.4 || exit 1

sudo mysql -e "SELECT VERSION();" || exit 1

### NodeJS 12

# Add NodeJS official repository and update packages list
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - || exit 1

# Install
sudo apt install -y nodejs || exit 1

node -v || exit 1
npm -v || exit 1

### Yarn 1.21

# Add Yarn official repository
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - || exit 1
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list || exit 1

# Update packages list
sudo apt update || exit 1

# Install
sudo apt install -y yarn=1.21* || exit 1

yarn -v || exit 1
