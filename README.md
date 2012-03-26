# Knife Block

Green and Secure IT Limited often have a need to work with multiple chef servers at the same time, be it due to testing/development/live scenarios or purely through working for a number of clients at once.

The knife block plugin has been created to enable the use of multiple knife.rb files against multiple chef servers.

The premise is that you have a "block" in which you store all your "knives" and you can choose the one best suited to the task.

## Installation

    gem install knife-block


### How does it work?

Knife looks for knife.rb in ~/.chef - all this script does is create a symlink from the required configuration to knife.rb so that knife can act on the appropriate server.

Create a knife-<service_name>.rb configuration file in your ~/.chef directory for each Chef server that you wish to connect to. 

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
(Launches "knife configure" and creates $HOME/.chef/knife-<friendlyname>.rb)

    knife block new <friendlyname>



These knife plugins are supplied without any warranty or guarantees regarding suitability for purpose.

Copyright: Green and Secure IT Limited 2012

License: Apache 2 (http://apache.org/licenses/LICENSE-2.0.html)
