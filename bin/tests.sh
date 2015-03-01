#!/usr/bin/env bash

# Check if there is an argument for chefdk, if there is
# install chefdk and use it's ruby, otherwise use the
# one provided by travis-ci

if [[ -n $1 ]]; then
  CHEF_DK_INSTALL=$1
  if [[ $CHEF_DK_INSTALL == true ]]; then
    source ./bin/chef_dk_install.sh
    ubuntu_check
    echo "Installing chefdk"
    install_chefdk
  fi
fi

# Run our tests
bundle install --jobs=3 --retry=3
bundle exec rake

