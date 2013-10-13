require 'spec_helper'
require 'ostruct'

module BigMac
  module Prerequisites
    describe Chef do
      let(:chef) { Chef.new }
      let(:chef_not_found_message) { '-bash: /usr/bin/chef-client: No such file or directory' }
      let(:chef_not_found) { OpenStruct.new(:stdout => chef_not_found_message) }
      let(:chef_found) { OpenStruct.new(:stdout => "Chef: 11.4.4\n") }

      describe "#verify" do
        it "should install chef if chef not already installed" do
          chef.should_receive(:shell_out).with(Chef::VERSION_CMD).and_return { chef_not_found }
          chef.should_receive(:shell_out!).with(Chef::INSTALL_CMD, :live_stream => STDOUT)
          chef.should_receive(:shell_out).with(Chef::VERSION_CMD).and_return { chef_found }
          chef.should_receive(:shell_out!).with(Chef::CHMOD_CMD)
          chef.verify
        end

        it "should not install chef if it is already installed" do
          chef.should_receive(:shell_out).at_least(:once).with(Chef::VERSION_CMD).and_return { chef_found }
          chef.should_not_receive(:shell_out!).with(Chef::INSTALL_CMD, :live_stream => STDOUT)
          chef.verify
        end
      end
    end
  end
end