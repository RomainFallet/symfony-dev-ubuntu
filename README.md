# The PHP/Symfony dev instructions kit for Ubuntu

![logo-ubuntu](https://user-images.githubusercontent.com/6952638/78182032-b119d300-7465-11ea-9e00-43e3d7265f91.png)

**This repository is part of the [symfony-dev-deploy](https://github.com/RomainFallet/symfony-dev-deploy) repository.**

![Test dev env install script](https://github.com/RomainFallet/symfony-dev-windows/workflows/Test%20dev%20env%20install%20script/badge.svg)

The purpose of this repository is to provide instructions to configure a PHP/Symfony development environment on **Ubuntu 18.04**.

The goal is to provide an opinionated, fully tested environment, that just work.

These instructions are also available for [macOS](https://github.com/RomainFallet/symfony-dev-macos) and [Windows](https://github.com/RomainFallet/symfony-dev-windows).

## Table of contents

* [Important notice](#important-notice)
* [Quickstart](#quickstart)
* [Manual configuration](#manual-configuration)
    1. [Prerequisites](#prerequisites)
    2. [Git](#git)
    3. [Symfony CLI](#symfony-cli)
    4. [PHP 7.3](#php-73)
    5. [Composer 1.9](#composer-19)
    6. [MariaDB 10.4](#mariadb-104)
    7. [NodeJS 12](#nodejs-12)
    8. [Yarn 1.21](#yarn-121)

## Important notice

Configuration script for dev environment is meant to be executed after a fresh installation of the OS.

Its purpose in not to be bullet-proof neither to handle all cases. It's  just here to get started quickly as it just executes the exact same commands listed in "manual configuration" section.

**So, if you have any trouble a non fresh-installed machine, please use "manual configuration" sections to complete your installation environment process.**

## Quickstart

[Back to top ↑](#table-of-contents)

```bash
# Get and execute script directly
bash -c "$(wget --no-cache -O- https://raw.githubusercontent.com/RomainFallet/symfony-dev-ubuntu/master/ubuntu18.04_configure_dev_env.sh)"
```

*See [manual instructions](#manual-configuration) for details.*

## Manual configuration

### Prerequisites

[Back to top ↑](#table-of-contents)

![curl](https://user-images.githubusercontent.com/6952638/70372369-31785f00-18de-11ea-9835-2946537372ea.jpg)

On Ubuntu, CURL is needed in order to install some packages with the default package manager.

```bash
# Update packages list
sudo apt update

# Install
sudo apt install -y software-properties-common curl
```

### Git

[Back to top ↑](#table-of-contents)

![git](https://user-images.githubusercontent.com/6952638/71176962-3a1c4e00-226b-11ea-83a1-5a66bd37a68b.png)

```bash
# Install
sudo apt install -y git

# Configure Git
git config --global user.name "$(read -r -p 'Enter your Git name: ' gitname && echo "${gitname}")"
git config --global user.email "$(read -r -p 'Enter your Git email: ' gitemail && echo "${gitemail}")"
```

### Symfony CLI

[Back to top ↑](#table-of-contents)

![symfony](https://user-images.githubusercontent.com/6952638/71176964-3ab4e480-226b-11ea-8522-081106cbff50.png)

```bash
# Download executable in local user folder
curl -sS https://get.symfony.com/cli/installer | bash

# Move the executable in global bin directory in order to use it globally
sudo mv ~/.symfony/bin/symfony /usr/local/bin/symfony
```

### PHP 7.3

[Back to top ↑](#table-of-contents)

![php](https://user-images.githubusercontent.com/6952638/70372327-bca52500-18dd-11ea-8638-7cdab7c5d6e0.png)

```bash
# Add PHP official repository
sudo add-apt-repository -y ppa:ondrej/php

# Install
sudo apt install -y php7.3

# Install extensions
sudo apt install -y php7.3-mbstring php7.3-mysql php7.3-xml php7.3-curl php7.3-zip php7.3-intl php7.3-gd php-xdebug

# Make a backup of the config file
phpinipath=$(php -r "echo php_ini_loaded_file();")
sudo cp "${phpinipath}" "$(dirname "${phpinipath}")/.php.ini.backup"

# Update some configuration in php.ini
sudo sed -i'.tmp' -e 's/post_max_size = 8M/post_max_size = 64M/g' "${phpinipath}"
sudo sed -i'.tmp' -e 's/upload_max_filesize = 8M/upload_max_filesize = 64M/g' "${phpinipath}"
sudo sed -i'.tmp' -e 's/memory_limit = 128M/memory_limit = -1/g' "${phpinipath}"
sudo sed -i'.tmp' -e 's/display_errors = Off/display_errors = On/g' "${phpinipath}"
sudo sed -i'.tmp' -e 's/display_startup_errors = Off/display_startup_errors = On/g' "${phpinipath}"
sudo sed -i'.tmp' -e 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/g' "${phpinipath}"

# Remove temporary file
sudo rm "${phpinipath}.tmp"

# Replace default PHP installation in $PATH
sudo update-alternatives --set php /usr/bin/php7.3
```

**Installed PHP Modules:** calendar, Core, ctype, curl, date, dom, exif, fileinfo, filter, ftp, gettext, hash, iconv, json, libxml, mbstring, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_mysql, Phar, posix, readline, Reflection, session, shmop, SimpleXML, sockets, sodium, SPL, standard, sysvmsg, sysvsem, sysvshm, tokenizer, wddx, xdebug, xml, xmlreader, xmlwriter, xsl, Zend OPcache, zip, zlib

**Installed Zend Modules:** Xdebug, Zend OPcache

### Composer 1.9

[Back to top ↑](#table-of-contents)

![composer](https://user-images.githubusercontent.com/6952638/70372308-a008ed00-18dd-11ea-9ee0-61d017dfa488.png)

```bash
# Download installer
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

# Install
sudo php composer-setup.php --version=1.9.1 --install-dir=/usr/local/bin/

# Remove installer
sudo php -r "unlink('composer-setup.php');"

# Make it executable globally
sudo mv /usr/local/bin/composer.phar /usr/local/bin/composer
```

### MariaDB 10.4

[Back to top ↑](#table-of-contents)

![mariadb](https://user-images.githubusercontent.com/6952638/71176963-3a1c4e00-226b-11ea-9627-e64caabef009.png)

Ubuntu 18.04:

```bash
# Add MariaDB official repository
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo -E bash

# Install
sudo apt install -y mariadb-server-10.4
```

### NodeJS 12

[Back to top ↑](#table-of-contents)

![node](https://user-images.githubusercontent.com/6952638/71177167-a4cd8980-226b-11ea-9095-c96d5b96faa7.png)

```bash
# Add NodeJS official repository and update packages list
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

# Install
sudo apt install -y nodejs
```

### Yarn 1.21

[Back to top ↑](#table-of-contents)

![yarn](https://user-images.githubusercontent.com/6952638/70372314-a13a1a00-18dd-11ea-9cdb-7b976c2beab8.png)

```bash
# Add Yarn official repository
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Update packages list
sudo apt update

# Install
sudo apt install -y yarn=1.21*
```
