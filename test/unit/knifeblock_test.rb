# Tests for knifeblock
#
# Copyright (c) 2012 Green and Secure IT Limited / Matthew Macdonald-Wallace

require 'chef/knife'
require './lib/chef/knife/block'
require 'test/unit'

class TestKnifeBlock < Test::Unit::TestCase

    def test_list_file 
    	chef_path = "#{ENV['WORKSPACE']}/.chef/"
    	knifeblock = GreenAndSecure::BlockList.new
	assert(!File.symlink?(chef_path+"/knife.rb"), "Knife.rb was not a symlink")
    end
end
