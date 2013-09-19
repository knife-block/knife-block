# knife-block - a plugin to enable the use of multiple knife configuration files
# to allow interaction with multiple knife servers in an easy and consistent manner
#
# Based on a bash script by Kristian Van Der Vliet (vanders@liqwyd.com)
#
# Copyright (c) Matthew Macdonald-Wallace / Green and Secure IT Limited 2012
#

# Monkey patch ::Chef::Knife to give us back the config file, cause there's
# no public method to actually use the lookup logic
class Chef
  class Knife
    def get_config_file
      locate_config_file if not config[:config_file]
      File.dirname(config[:config_file])
    end
  end
end

module GreenAndSecure
  @@knife = ::Chef::Knife.new
  def chef_config_base
    @@knife.get_config_file
  end
  module_function :chef_config_base

  def check_block_setup
    base = GreenAndSecure::chef_config_base
    if File.exists?(base+"/knife.rb") then
      if !File.symlink?(base+"/knife.rb") then
        puts "#{base}/knife.rb is NOT a symlink."
        puts "Please copy the file to #{base}/knife-<servername>.rb and re-run this command."
        exit 3
      end
    end
  end
  module_function :check_block_setup

  def printable_server(server_config)
    File.basename(server_config, ".rb").split('-')[1 .. -1].join('-')
  end
  module_function :printable_server

  # Returns path to berkshelf
  def berkshelf_path
    @berkshelf_path ||= ENV['BERKSHELF_PATH'] || File.expand_path('~/.berkshelf')
  end
  module_function :berkshelf_path

  class Block < Chef::Knife

    banner "knife block"

    def run
      GreenAndSecure::check_block_setup
      list = GreenAndSecure::BlockList.new
      if name_args.size == 1 and list.servers.include?(name_args[0])
        use = GreenAndSecure::BlockUse.new
        use.name_args = name_args
        use.run
      else
        puts 'Did you mean to run "knife block list" instead?'
        puts 'Running "knife block list" for you now'
        list.run
      end
    end
  end

  class BlockList < Chef::Knife

    banner "knife block list"

    @current_server = nil
    def current_server
      GreenAndSecure::check_block_setup

      @current_server ||= if File.exists?(GreenAndSecure::chef_config_base+"/knife.rb") then
        GreenAndSecure::printable_server(File.readlink(GreenAndSecure::chef_config_base+"/knife.rb"))
      else
        nil
      end
    end

    @servers = []
    def servers
      ## get the list of available environments by searching ~/.chef for knife.rb files
      @servers ||= Dir.glob(GreenAndSecure::chef_config_base+"/knife-*.rb").sort.map do | fn |
        GreenAndSecure::printable_server(fn)
      end
    end

    # list the available environments
    def run
      GreenAndSecure::check_block_setup
      puts "The available chef servers are:"
      servers.each do |server|
        if server == current_server then
          puts "\t* #{server} [ Currently Selected ]"
        else
          puts "\t* #{server}"
        end
      end
    end
  end

  class BlockUse < Chef::Knife

    banner "knife block use SERVERNAME"

    def run
      unless name_args.size == 1
        puts "Please specify a server"
        server_list = GreenAndSecure::BlockList.new
        server_list.run
      exit 1
      end
      list = GreenAndSecure::BlockList.new
      new_server = name_args.first

      base = GreenAndSecure::chef_config_base
      if File.exists?(base+"/knife-#{new_server}.rb")
        if File.exists?(base+"/knife.rb")
          File.unlink(base+"/knife.rb")
        end
        File.symlink(base+"/knife-#{new_server}.rb",
          base+"/knife.rb")
        puts "The knife configuration has been updated to use #{new_server}"

        # update berkshelf
        berks = GreenAndSecure::berkshelf_path+"/config.json"
        berks_new = GreenAndSecure::berkshelf_path+"/config-#{new_server}.json"
        if File.exists?(berks_new)
          if File.exists?(berks)
            File.unlink(berks)
          end
          File.symlink(berks_new, berks)
            puts "The berkshelf configuration has been updated to use #{new_server}"
          else
            puts "Berkshelf configuration for #{new_server} not found"
          end
        else
          puts "Knife configuration for #{new_server} not found, aborting switch"
      end
    end
  end

  class BlockNew < Chef::Knife

    banner "knife block new SERVERNAME"

    def run
      puts "This will create a new knife configuration file for you to use with knife-block"
      unless name_args.size == 1
        @config_name = ui.ask_question("Please provide a friendly name for the new configuration file: ")
      else
        @config_name = name_args.first
      end

      @chef_server = ui.ask_question("Please enter the url to your Chef Server: ")
      @client_name = ui.ask_question("Please enter the name of the Chef client: ")

      require 'ohai'
      require 'chef/knife/configure'

      GreenAndSecure::check_block_setup
      knife_config = Chef::Knife::Configure.new
      knife_config.config[:config_file] = "#{GreenAndSecure::chef_config_base}/knife-#{@config_name}.rb"
      knife_config.config[:chef_server_url] = @chef_server
      knife_config.config[:node_name] = @client_name
      knife_config.config[:client_key] = "#{GreenAndSecure::chef_config_base}/#{@client_name}-#{@config_name}.pem"
      knife_config.run

      puts "#{GreenAndSecure::chef_config_base}/knife-#{@config_name}.rb has been sucessfully created"
      GreenAndSecure::BlockList.new.run
      use = GreenAndSecure::BlockUse.new
      use.name_args = [ @config_name ]
      use.run
    end
  end
end

