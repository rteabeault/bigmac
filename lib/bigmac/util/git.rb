module BigMac
  module Git
    include Mixin::ShellOut

    GIT = '/usr/bin/git'

    class << self
      def clone(url, to)
        cmd = shell_out %Q{#{GIT_COMMAND} clone #{url} #{to}}
        if cmd.exitstatus != 0
          raise GitCloneError.new(url, cmd.stderr)
        end
      end
    end
  end
end