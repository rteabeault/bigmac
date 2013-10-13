module BigMac
  class Berks
    BERKS_COMMAND = '/opt/chef/embedded/bin/berks'
    class << self
      def install(berksfile, path)
        berksfile_home = File.dirname(berksfile)
        BigMac.ui.banner("Running berkshelf...Ermagherd!")
        Dir.chdir(berksfile_home) do
          FileUtils.rm 'Berksfile.lock' if File.exist? 'Berksfile.lock'
          shell_out! "#{BERKS_COMMAND} install -p #{path}", :live_stream => STDOUT
        end
      end
    end
  end
end