#!/usr/bin/env bash

# Check if there is an argument for chefdk, if there is
# install chefdk and use it's ruby, otherwise use the
# one provided by travis-ci

if $TRAVIS_OS_NAME == "linux"; then
  if [[ -n $1 ]]; then
    CHEF_DK_INSTALL=$1
    if [[ $CHEF_DK_INSTALL == true ]]; then
      source ./bin/chef_dk_install.sh

      echo "Installing chefdk"
      install_chefdk
    fi
  fi
fi

# Run our tests
bundle install --jobs=3 --retry=3
bundle exec rake rubocop
bundle exec rake

mkdir ~/.chef
echo 1 > ~/.chef/knife-my-cool-server.rb

echo "Testing knife block list"
bundle exec knife block list > /tmp/knife_block_list.txt
echo "Output of knife block list"
cat /tmp/knife_block_list.txt

echo "Testing if knife block list worked as expected"
grep 'my-cool-server' /tmp/knife_block_list.txt
if [[ $? != 0 ]]
then
  echo "No knife config found and it should have found it"
  exit 1
fi
