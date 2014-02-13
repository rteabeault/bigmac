module BigMac
  module Prerequisites
    module OSX
      module Mavericks
        class CommandLineTools < Prerequisite
          def initialize(options = {})
            super("OS X Command Line Tools for Mavericks")

            @version_cmd = 'pkgutil --pkg-info=com.apple.pkg.CLTools_Executables'
            @version_regex = /version:\s(.*)\n/
            @install_cmd = <<-SCRIPT
              touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
              PROD=$(softwareupdate -l | grep -B 1 "Developer" | head -n 1 | awk -F"*" '{print $2}')
              sudo softwareupdate -i $PROD -v
            SCRIPT
          end
        end
      end
    end
  end
end