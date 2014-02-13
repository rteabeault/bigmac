module BigMac
  module Prerequisites
    class Berkshelf < Prerequisite
      VERSION_CMD = '/opt/chef/embedded/bin/berks --version'
      INSTALL_CMD = '/opt/chef/embedded/bin/gem install berkshelf --pre --no-ri --no-rdoc'

      def initialize
        super("Berkshelf (Ermagherd!)")
        @version_cmd = VERSION_CMD
        @version_regex = /(.*)/
        @install_cmd = INSTALL_CMD
      end
    end
  end
end