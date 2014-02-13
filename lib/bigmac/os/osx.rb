module BigMac
  module OS
    puts "Loading OSX"
    class OSX < GenericOS
      class << self
        include Mixin::ShellOut

        def flavor
          osx_codename = codename(shell_out('uname -r').stdout.strip)
          case osx_codename
          when "Mavericks"
            Mavericks.new
          else
            raise "OS X [#{osx_codename}] is not supported. Feel free to submit a pull request."
          end
        end

        def codename(version)
          case version
          when /^13\.\d+\.\d+/
            "Mavericks"
          when /^12\.\d+\.\d+/
            "Mountain Lion"
          when /^11\.\d+\.\d+/
            "Lion"
          else
            "old ass"
          end
        end
      end
    end

    class Mavericks < OSX
      def prerequisites
        [
          BigMac::Prerequisites::Chef.new,
          BigMac::Prerequisites::OSX::Mavericks::CommandLineTools.new,
          BigMac::Prerequisites::Berkshelf.new
        ]
      end
    end
  end
end