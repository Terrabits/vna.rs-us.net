#!/usr/bin/env bash

# Silent
export DEBIAN_FRONTEND=noninteractive
export RAILS_ENV=production

# Update package list
sudo apt-get update

# Linux security updates
# sudo apt-get unattended-upgrade
# sudo unattended-upgrade

# Curl
sudo apt-get install curl -y

# Build tools
# sudo apt-get install build-essential

# rvm
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable # --ruby # Want to pick ruby version
source /home/vagrant/.rvm/scripts/rvm

# Install ruby, create gemset
rvm install 2.3.1
rvm gemset create vna.rs-us.net

# Use ruby@gemset
rvm use 2.3.1
rvm gemset use vna.rs-us.net

# Install gem
cd /vagrant
gem install bundler
bundle install

# Install node.js for execjs ruby gem
sudo apt-get install nodejs -y

# Python
# sudo apt-get install python-dev -y
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
echo "export PATH=\"/home/vagrant/.pyenv/bin:\$PATH\"" >> ~/.bash_profile
echo "eval \"\$(pyenv init -)\"" >> ~/.bash_profile
echo "eval \"\$(pyenv virtualenv-init -)\"" >> ~/.bash_profile
pyenv update

# scour (SVG cleanup)
pyenv install 3.5.2
pyenv virtualenv 3.5.2 scour
pyenv shell scour
pip install --upgrade pip
pip install scour
