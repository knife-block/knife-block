#!/usr/bin/env bash

# helper script to install chefdk for testing on travis-ci

ubuntu_check(){
  grep 'Ubuntu' /etc/issue

  if [[ $? != 0 ]]; then
    echo "This is only meant to run on Ubuntu!"
    exit 1
  fi
}

install_chefdk() {
  ubuntu_check

  curl -s https://packagecloud.io/gpg.key | sudo apt-key add -
  echo "deb https://packagecloud.io/chef/stable/ubuntu/ precise main" \
    | sudo tee -a /etc/apt/sources.list.d/chef.list
  sudo apt-get update -qq
  sudo apt-get install -yqq chefdk
  chef verify > /dev/null 2>&1
  chefdk_installed_correctly=$?
  if [[ $chefdk_installed_correctly != 0 ]]; then
    echo "ChefDK not installed correctly, failing"
    exit 1
  fi
  eval "$(chef shell-init bash)"
}

