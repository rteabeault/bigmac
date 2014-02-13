module BigMac
  module OS
    autoload :OSX, 'bigmac/os/osx'

    class << self
      include Mixin::ShellOut
      def current
        case shell_out('uname -s').stdout.strip
        when "Darwin"
          OSX.flavor
        end
      end
    end

    class GenericOS
      def install_prerequisites!
        prerequisites.each do |prereq|
          prereq.verify!
        end
      end

      def prerequisites
        raise 'method is abstract!'
      end
    end
  end
end

