module BigMac
  module Prerequisites
    class Chef < Prerequisite
      include Mixin::ShellOut

      VERSION_CMD = '/opt/chef/bin/chef-client -version'
      INSTALL_CMD = 'curl -L https://www.opscode.com/chef/install.sh | sudo bash'
      CHMOD_CMD   = 'sudo chmod -R 777 /opt/chef/embedded'

      def initialize
        super("Chef")
        @version_cmd   = VERSION_CMD
        @version_regex = /Chef:\s(.*)/
        @install_cmd   = INSTALL_CMD
      end

      def verify_install
        super
        shell_out! CHMOD_CMD
      end
    end
  end
end