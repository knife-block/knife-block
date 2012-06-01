# knife-block - a plugin to enable the use of multiple knife configuration files
# to allow interaction with multiple knife servers in an easy and consistent manner
#
# Based on a bash script by Kristian Van Der Vliet (vanders@liqwyd.com)
#
# Copyright (c) Matthew Macdonald-Wallace / Green and Secure IT Limited 2012
#
module GreenAndSecure
    def check_block_setup
	if File.exists?(::Chef::Knife::chef_config_dir+"/knife.rb") then
	    if !File.symlink?(::Chef::Knife::chef_config_dir+"/knife.rb") then
		puts "#{::Chef::Knife::chef_config_dir}/knife.rb is NOT a symlink."
		puts "Please copy the file to #{::Chef::Knife::chef_config_dir}/knife-<servername>.rb and re-run this command."
		exit 3
	    end
	end
    end
    module_function :check_block_setup

    def printable_server(server_config)
	File.basename(server_config, ".rb").split('-')[1 .. -1].join('-')
    end
    module_function :printable_server

    class Block < Chef::Knife
    banner "knife block"
    	def run
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
	
            @current_server ||= if File.exists?(::Chef::Knife::chef_config_dir+"/knife.rb") then
                    GreenAndSecure::printable_server(File.readlink(::Chef::Knife::chef_config_dir+"/knife.rb"))
                else
                    nil
                end
        end

	@servers = []
        def servers
	    ## get the list of available environments by searching ~/.chef for knife.rb files
	    @servers ||= Dir.glob(::Chef::Knife::chef_config_dir+"/knife-*.rb").sort.map do | fn |
		    GreenAndSecure::printable_server(fn)
	        end
        end

    	# list the available environments
    	def run
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
       if File.exists?(::Chef::Knife::chef_config_dir+"/knife-#{new_server}.rb")
          if File.exists?(::Chef::Knife::chef_config_dir+"/knife.rb")
             File.unlink(::Chef::Knife::chef_config_dir+"/knife.rb")
          end
          File.symlink(::Chef::Knife::chef_config_dir+"/knife-#{new_server}.rb",
            ::Chef::Knife::chef_config_dir+"/knife.rb")
          puts "The knife configuration has been updated to use #{new_server}"
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
	    require 'ohai'
	    require 'chef/knife/configure'
            GreenAndSecure::check_block_setup
	    knife_config = Chef::Knife::Configure.new
	    knife_config.config[:config_file] = "#{::Chef::Knife::chef_config_dir}/knife-#{@config_name}.rb"
	    knife_config.config[:chef_server_url] = @chef_server
	    knife_config.run
	    puts "#{::Chef::Knife::chef_config_dir}/knife-#{@config_name}.rb has been sucessfully created"
	    GreenAndSecure::BlockList.new.run
	    use = GreenAndSecure::BlockUse.new
	    use.name_args = [ @config_name ]
	    use.run
	end
    end
end
