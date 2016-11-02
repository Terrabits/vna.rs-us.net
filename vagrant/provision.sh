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
