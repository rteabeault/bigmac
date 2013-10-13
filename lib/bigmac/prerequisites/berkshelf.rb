module BigMac
  module Prerequisites
    class Berkshelf < Prerequisite
      include Mixin::ShellOut

      VERSION_CMD = '/opt/chef/embedded/bin/berks --version'
      INSTALL_CMD = '/opt/chef/embedded/bin/gem install berkshelf --no-ri --no-rdoc'

      def initialize
        super("Berkshelf")
        @version_cmd = VERSION_CMD
        @version_regex = /Berkshelf\s\((.*)\)/
        @install_cmd = INSTALL_CMD
      end
    end
  end
end