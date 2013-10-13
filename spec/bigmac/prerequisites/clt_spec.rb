require 'spec_helper'

module BigMac
  module Prerequisites
    describe CommandLineTools do
      let(:clt) { CommandLineTools.new }
      let(:clt_not_found_message) { "No receipt for 'com.apple.pkg.DeveloperToolsCLI' found at '/'." }
      let(:clt_not_found) { OpenStruct.new(:stdout => clt_not_found_message) }
      let(:clt_found_message) { <<-CLT.gsub /^\s+/, ""
          package-id: com.apple.pkg.DeveloperToolsCLI
          version: 4.6.0.0.1.1362189000
          volume: /
          location: /
          install-time: 1365440034
          groups: com.apple.FindSystemFiles.pkg-group com.apple.DevToolsBoth.pkg-group com.apple.DevToolsNonRelocatableShared.pkg-group
        CLT
      }
      let(:clt_found) { OpenStruct.new(:stdout => clt_found_message) }

      describe "#verify" do
        it "should install command line tools if they are not already installed" do
          clt.should_receive(:shell_out).with(CommandLineTools::VERSION_CMD).and_return { clt_not_found }
          DmgInstaller.should_receive(:install).with(anything())
          clt.should_receive(:shell_out).with(CommandLineTools::VERSION_CMD).and_return { clt_found }
          clt.verify
        end

        it "should not install command line tools if it is already installed" do
          clt.should_receive(:shell_out).at_least(:once).with(CommandLineTools::VERSION_CMD).and_return { clt_found }
          DmgInstaller.should_not_receive(:install)
          clt.verify
        end
      end
    end
  end
end