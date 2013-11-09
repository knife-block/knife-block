# Tests for knifeblock
#
# Copyright (c) 2012 Green and Secure IT Limited / Matthew Macdonald-Wallace

require 'chef/knife'
require './lib/chef/knife/block'
require 'test/unit'

class TestGreenAndSecureModule < Test::Unit::TestCase

  def setup
    @@green = Object.new
    class << @@green
      include GreenAndSecure
    end
  end

  def test_001_it_detects_a_version
    assert_match(/\d+\.\d+\.\d+/,@@green.current_chef_version.to_s, "FAIL: Chef version undetected!")
  end

  def test_002_it_locates_a_knife_config
    assert_match(/.*\/.chef\/knife\.rb/,@@green.chef_config_base+"/knife.rb", "FAIL: knife.rb not found!")
  end
end

class TestKnifeBlockList < Test::Unit::TestCase

  def setup
    @@knifeblock = GreenAndSecure::BlockList.new
    ENV['WORKSPACE'] ? (@chef_path ||= "#{ENV['WORKSPACE']}/.chef") : @chef_path = "#{ENV['HOME']}/.chef"
  end

  def test_list_file
	  assert(File.symlink?(@chef_path+"/knife.rb"), "knife.rb was not a symlink, please copy the file to #{@chef_path}/knife-<servername>.rb")
  end
end
