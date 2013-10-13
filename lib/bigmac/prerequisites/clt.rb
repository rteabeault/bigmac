module BigMac
  module Prerequisites
    class CommandLineTools < Prerequisite
      include Mixin::ShellOut
      OS_NAME      = 'mountain_lion'
      VERSION      = 'april_2013'
      FILE         = "command_line_tools_for_xcode_os_x_#{OS_NAME}_#{VERSION}.dmg"
      DOWNLOAD_URL = "http://devimages.apple.com/downloads/xcode/#{FILE}"
      VERSION_CMD  = 'pkgutil --pkg-info=com.apple.pkg.DeveloperToolsCLI'

      def initialize(options = {})
        super("OS X Command Line Tools")

        @download_url = options[:clt_url] || DOWNLOAD_URL
        @version_cmd = VERSION_CMD
        @version_regex = /version:\s(.*)\n/
      end

      def install
        dmg_download = Proc.new { Downloader.download(@download_url) }
        @dmg = Dmg.new(dmg_download)

        DmgInstaller.install(@dmg)
      end
    end
  end
end