module BigMac
  module Git

    GIT = '/usr/bin/git'
    GIT_COMMAND = '/usr/bin/git'

    class << self
      include Mixin::ShellOut
      
      def clone(url, to)
        cmd = shell_out %Q{#{GIT_COMMAND} clone #{url} #{to}}
        if cmd.exitstatus != 0
          raise GitCloneError.new(url, cmd.stderr)
        end
      end

      def pull(path)
        Dir.chdir(path) do
          cmd = shell_out %Q{#{GIT_COMMAND} pull}
          if cmd.exitstatus != 0
            raise GitPullError.new(path, cmd.stderr)
          end
        end
      end
    end
  end
end