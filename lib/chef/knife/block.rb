# knife-block - a plugin to enable the use of multiple knife configuration files
# to allow interaction with multiple knife servers in an easy and consistent manner
#
# Based on a bash script by Kristian Van Der Vliet (vanders@liqwyd.com)
#
# Copyright (c) Matthew Macdonald-Wallace / Green and Secure IT Limited 2012
#
module GreenAndSecure
    class Block < Chef::Knife
    banner "knife block"
    	def run
	    puts 'Did you mean to run "knife block list" instead?'
	    puts 'Running "knife block list" for you now'
    	    list = GreenAndSecure::BlockList.new
    	    list.run
	end
    end
    class BlockList < Chef::Knife

	banner "knife block list"

    	# list the available environments
    	def run
	    chef_path = Dir.home + "/.chef"
	    ## get the list of available environments by searching ~/.chef for knife.rb files
	    file_list = Dir.glob(chef_path+"/knife-*.rb").sort
	    current_server = ""
	    if File.exists?(chef_path+"/knife.rb") then
		if !File.symlink?(chef_path+"/knife.rb") then
		    puts "#{chef_path}/knife.rb is NOT a symlink."
		    puts "Please copy the file to #{chef_path}/knife-<servername>.rb and re-run this command."
		    exit 3
		end
		    current_server = File.readlink(chef_path+"/knife.rb").split('-')[1 .. -1].join('-').split('.')[0]
	    end
	    servers = []
	    file_list.each do | fn |
		servers << fn.split('-')[1 .. -1].join('-').split('.')[0]
	    end
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
	    chef_path = Dir.home + "/.chef"
	    current_server = ""
	    if File.exists?(chef_path+"/knife.rb") then
		if !File.symlink?(chef_path+"/knife.rb") then
		    puts "#{chef_path}/knife.rb is NOT a symlink."
		    puts "Please copy the file to #{chef_path}/knife-<servername>.rb and re-run this command."
		    exit 3
		end
		    current_server = File.readlink(chef_path+"/knife.rb").split('-')[1 .. -1].join('-').split('.')[0]
	    end
	    new_server = name_args.first
	    ui.confirm("You are asking to change from #{current_server} to #{new_server}. Are you sure")
	    if File.exists?(chef_path+"/knife.rb")
		    File.unlink(chef_path+"/knife.rb")
	    end
	    File.symlink(chef_path+"/knife-#{new_server}.rb",chef_path+"/knife.rb")
	    if File.exists?(chef_path+"/knife.rb") then
		    current_server = File.readlink(chef_path+"/knife.rb").split('-')[1 .. -1].join('-').split('.')[0]
	    end
	    puts "The knife configuration has been updated to use #{current_server}"
	end
    end
    class BlockNew < Chef::Knife
    	banner "knife block new SERVERNAME"
    	def run
    	    chef_path = Dir.home + "/.chef"
    	    puts "This will create a new knife configuration file for you to use with knife-block"
    	    unless name_args.size == 1
    	    	@config_name = ui.ask_question("Please provide a friendly name for the new configuration file: ")
	    else
		@config_name = name_args.first
	    end

	    @chef_server = ui.ask_question("Please enter the url to your Chef Server: ")
	    require 'ohai'
	    require 'chef/knife/configure'
	    if File.exists?(chef_path+"/knife.rb") then
		if !File.symlink?(chef_path+"/knife.rb") then
		    puts "#{chef_path}/knife.rb already exists!"
		    puts "Please copy the file to #{chef_path}/knife-<servername>.rb and re-run this command."
		    exit 3
		end
	    end
	    knife_config = Chef::Knife::Configure.new
	    knife_config.config[:config_file] = "#{chef_path}/knife-#{@config_name}.rb"
	    knife_config.config[:chef_server_url] = @chef_server
	    knife_config.run
	    puts "#{chef_path}/knife-#{@config_name}.rb has been sucessfully created"
	    GreenAndSecure::BlockList.new.run
	    ui.confirm("Would you like to switch to it now? ")
	    if File.exists?(chef_path+"/knife.rb")
		    File.unlink(chef_path+"/knife.rb")
	    end
	    File.symlink(chef_path+"/knife-#{@config_name}.rb",chef_path+"/knife.rb")
	    if File.exists?(chef_path+"/knife.rb") then
		    current_server = File.readlink(chef_path+"/knife.rb").split('-')[1 .. -1].join('-').split('.')[0]
	    end
	    puts "The knife configuration has been updated to use #{current_server}"
	end
    end
end
