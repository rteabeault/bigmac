require 'mixlib/shellout'

module BigMac
  module Mixin
    module ShellOut
      def shell_out(*command_args)
        cmd = Mixlib::ShellOut.new(*command_args)
        with_clean_env { cmd.run_command }
        cmd
      end

      def shell_out!(*command_args)
        cmd = shell_out(*command_args)
        cmd.error!
        cmd
      end

      private

      def with_clean_env
        original_env = ENV.to_hash

        begin
          gem_home = ENV.delete('GEM_HOME')
          gem_path = ENV.delete('GEM_PATH')
          ENV['GIT_ASKPASS'] = 'echo'
          ENV.delete_if { |k,_| k[0,7] == 'BUNDLE_' }
          if ENV.has_key? 'RUBYOPT'
            ENV['RUBYOPT'] = ENV['RUBYOPT'].sub '-rbundler/setup', ''
            ENV['RUBYOPT'] = ENV['RUBYOPT'].sub "-I#{File.expand_path('..', __FILE__)}", ''
          end
          yield
        ensure
          ENV.replace(original_env)
        end
      end
    end
  end
end