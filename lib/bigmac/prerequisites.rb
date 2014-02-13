module BigMac
  module Prerequisites
    autoload :OSX, 'bigmac/prerequisites/osx'
    autoload :Chef, 'bigmac/prerequisites/chef'
    autoload :Berkshelf, 'bigmac/prerequisites/berkshelf'

    class << self
    end

    class Prerequisite
      include Mixin::ShellOut

      attr_reader :name, :version_cmd, :version_regex, :install_cmd

      def initialize(name)
        @name = name
      end

      def installed?
        version != nil
      end

      def version
        begin
         shell_out(version_cmd).stdout.match(version_regex)
         $1
        rescue Errno::ENOENT
          nil
        end
      end

      def install
        shell_out! install_cmd, :live_stream => STDOUT
      end

      def verify_install
        raise "Installation was not successful" unless installed?
      end

      def verify!
        BigMac.ui.banner("Checking prerequisite [#{name}]")
        if installed?
          BigMac.ui.info("[#{name}] with version [#{version}] already installed")
        else
          BigMac.ui.info("Installing [#{name}]...")
          install
        end

        verify_install
      end
    end
  end
end