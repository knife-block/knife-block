# Tests for knifeblock
#
# Copyright (c) 2012 Green and Secure IT Limited / Matthew Macdonald-Wallace

require 'chef/knife'
require './lib/chef/knife/block'
require 'test/unit'
require 'fileutils'

class TestGreenAndSecureModule < Test::Unit::TestCase

  def setup
    @green = Object.new
    class << @green
      include GreenAndSecure
    end

    ENV['WORKSPACE'] ? (@chef_path ||= "#{ENV['WORKSPACE']}/.chef") : @chef_path = "#{ENV['HOME']}/.chef"
    if ENV['TRAVIS']
      @knife_ci = "#{@chef_path}/knife-ci.rb"
      FileUtils.mkpath(@chef_path) unless File.exists?(@chef_path)
      FileUtils.touch("#{@knife_ci}") unless File.exists?("#{@knife_ci}")
      FileUtils.ln_s("#{@knife_ci}","#{@chef_path}/knife.rb") unless File.exists?("#{@chef_path}/knife.rb")
    end
  end

  def teardown
    if ENV['TRAVIS']
      FileUtils.remove_entry_secure(@chef_path, force = true) if File.exists?(@chef_path)
    end
  end

  def test_001_it_detects_a_version
    assert_match(/\d+\.\d+\.\d+/,@green.current_chef_version.to_s, "FAIL: Chef version undetected!")
  end

  def test_002_it_locates_a_knife_config
    assert_match(/.*\/.chef\/knife\.rb/,@green.chef_config_base+"/knife.rb", "FAIL: knife.rb not found!")
  end

  def test_003_knife_rb_is_a_symlink
    assert(File.symlink?(@chef_path+"/knife.rb"), "knife.rb was not a symlink, please link it to #{@chef_path}/knife-<servername>.rb")
  end
end
