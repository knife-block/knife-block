# Knife Block

The knife block plugin has been created to enable the use of multiple knife.rb files against multiple chef servers.

The premise is that you have a "block" in which you store all your "knives" and you can choose the one best suited to the task.

![Knife Block](/assets/knife-block.png)

## Requirements

At present, knife-block requires ruby 1.9.2 or above.  This is owing to the use of "Dir.home()" to find a user's home directory.

## Installation

If you've installed Chef via rubygems, homebrew, etc, then install using

    gem install knife-block

If you've installed Chef via ChefDK, then install using

    chef gem install knife-block

### How does it work?

Knife looks for knife.rb in ~/.chef - all this script does is create a symlink from the required configuration to knife.rb so that knife can act on the appropriate server.

Create a knife-&lt;service_name&gt;.rb configuration file in your ~/.chef directory for each Chef server that you wish to connect to.

**Please note - this script will check to see if knife.rb exists and whether it is a symlink or not.**

**If knife.rb is *not* a symlink, the program will exit immediately and tell you what to do.**

#### List all available servers
(This command will also tell you which server is currently selected)

    knife block list

    The available chef servers are:
        * local-testing [ Currently Selected ]
        * opscode-hosted-chef

#### Change to a new server
    knife block use <server_name>

    You are asking to change from local-testing to opscode-hosted-chef. Are you sure? (Y/N) y
    The knife configuration has been updated to use opscode-hosted-chef

#### Create a new server
(Launches "knife configure" and creates $HOME/.chef/knife-&lt;friendlyname&gt;.rb)

    knife block new <friendlyname>


### Berkshelf integration
Knife block supports Berkshelf, however, the berkshelf config files must be manually created and named "config-&lt;block&gt;.json" and put in the Berkshelf directory (typically ~/.berkshelf). In the future, these files could be automatically created by knife block.


These knife plugins are supplied without any warranty or guarantees regarding suitability for purpose.

The code requires far more tests than the simple one that currently exists.

Having said all of that, it works for us!

Copyright:
- Brandon Burton, 2015
- Green and Secure IT Limited, 2012 - 2015

License: Apache 2 (http://apache.org/licenses/LICENSE-2.0.html)
