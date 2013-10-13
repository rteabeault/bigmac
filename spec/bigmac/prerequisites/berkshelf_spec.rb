require 'spec_helper'

module BigMac
  module Prerequisites
    describe Berkshelf do
      let(:berkshelf) { Berkshelf.new }
      let(:berks_not_found_message) { '-bash: /opt/chef/embedded/bin/berks: No such file or directory' }
      let(:berks_not_found) { OpenStruct.new(:stdout => berks_not_found_message) }
      let(:berks_found) { OpenStruct.new(:stdout => "Berkshelf (2.0.1)\n\nCopyright 2012-2013 Riot Games\n") }

      describe "#verify" do
        it "should install berkshelf if berkshelf not already installed" do
          berkshelf.should_receive(:shell_out).with(Berkshelf::VERSION_CMD).and_return { berks_not_found }
          berkshelf.should_receive(:shell_out!).with(Berkshelf::INSTALL_CMD, :live_stream => STDOUT)
          berkshelf.should_receive(:shell_out).with(Berkshelf::VERSION_CMD).and_return { berks_found }
          berkshelf.verify
        end

        it "should not install berkshelf if it is already installed" do
          berkshelf.should_receive(:shell_out).at_least(:once).with(Berkshelf::VERSION_CMD).and_return { berks_found }
          berkshelf.should_not_receive(:shell_out!).with(Berkshelf::INSTALL_CMD, :live_stream => STDOUT)
          berkshelf.verify
        end
      end
    end
  end
end