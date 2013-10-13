module BigMac
  class DmgInstaller
    extend Mixin::ShellOut

    class << self
      def install(dmg, options = {})
        glob = options[:glob] || "**/*.mpkg"

        begin
          mount_path = dmg.attach
          installer_glob = File.join(mount_path, glob)
          installer_path = Dir.glob(installer_glob)[0]

          if installer_path.nil?
            raise "Could not find installer with glob #{installer_glob}"
          end

          shell_out! %Q{sudo installer -pkg "#{installer_path}" -target /}
        ensure
          dmg.detach
        end
      end
    end
  end
end