module BigMac
  module GithubKeychain
    extend Mixin::ShellOut

    class << self
      def with_password_in_keychain(username, password)
        begin
          exists = password_in_keychain?

          unless exists
            add_password(username, password)
          end

          yield
        ensure
          unless exists
            delete_password(username, password)
          end
        end
      end

      def password_in_keychain?
        cmd = shell_out %Q{security find-internet-password -s github.com -r htps}
        cmd.exitstatus == 0
      end
      
      def add_password(username, password)
        shell_out! %Q{security add-internet-password -s github.com -r htps -a #{username} -w #{password} -T '/usr/libexec/git-core/git-credential-osxkeychain'}
      end

      def delete_password(username, password)
        shell_out! %Q{security delete-internet-password -s github.com -r htps -a #{username}}
      end
    end
  end
end