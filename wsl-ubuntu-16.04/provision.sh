#!/usr/bin/env bash
set -o errexit   # exit on error
set -o pipefail  # exit on error in pipes
# set -o nounset   # exit on unset variable
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
# cd "$ROOT_DIR"

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

# need to update certificates for curl to work properly

# update certificates
sudo apt-get install -y ca-certificates openssl

# remove old certificate
sed -i 's|^mozilla/DST_Root_CA_X3.crt|!mozilla/DST_Root_CA_X3.crt|' /etc/ca-certificates.conf

# rebuild certificates
update-ca-certificates


# Build tools
# sudo apt-get install build-essential


# rvm
# gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# \curl -sSL https://get.rvm.io | bash -s stable # --ruby # Want to pick ruby version
# source /home/vagrant/.rvm/scripts/rvm

# install gpg2
sudo apt install gnupg2 -y

# import both keys into gpg2 (the primary binary RVM uses)
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -

# also import into gpg v1 as a fallback
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -

# 3. Trust both keys
echo "409B6B1796C275462A1703113804BB82D39DC0E3:6:" | gpg2 --import-ownertrust
echo "7D2BAF1CF37B13E2069D6956105BD0E739499BDB:6:" | gpg2 --import-ownertrust

# Install RVM stable
sudo apt-get install -y lsb-release
\curl -sSL https://get.rvm.io | bash -s stable

# 3. Load RVM from the system-wide root install path
source /usr/local/rvm/scripts/rvm


# Install ruby, create gemset
rvm install 2.3.1
rvm use 2.3.1@vna.rs-us.net --create

# Install gem
gem install bundler -v 1.17.3
bundle _1.17.3_ install

# Install node.js for execjs ruby gem
sudo apt-get install nodejs -y

# install pyenv, python and packages

# update certificates
curl -k -L https://curl.se -o /usr/local/share/ca-certificates/mozilla-cacert.crt
update-ca-certificates

curl -k -fsSL https://curl.se -o /etc/ssl/certs/cacert.pem

export CURL_CA_BUNDLE=/etc/ssl/certs/cacert.pem
export SSL_CERT_FILE=/etc/ssl/certs/cacert.pem
git config --global http.sslCAInfo /etc/ssl/certs/cacert.pem


# sudo apt-get install python-dev -y
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils
curl -fsSL https://pyenv.run | bash

# add pyenv to shell session
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# persist pyenv to future shell sessions
# Persist pyenv to ~/.bashrc for future WSL logins
cat << 'EOF' >> ~/.bashrc
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF

# scour (SVG cleanup)
PYTHON_BUILD_CURL_OPTS="-k" pyenv install 3.5.2
pyenv virtualenv 3.5.2 scour
pyenv activate scour
pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org "pip<21.0"
pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org scour
