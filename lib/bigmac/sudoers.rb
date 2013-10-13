# encoding: UTF-8
module BigMac
  class Sudoers
    include Mixin::ShellOut

    attr_reader :sudoers_file, :contents

    def initialize(sudoers_file = '/etc/sudoers')
      @sudoers_file = sudoers_file
      @contents = parse_contents
    end

    def add_passwordless_sudo(id = '%admin')
      unless passwordless_sudo_enabled?(id)
        contents.map! do |line|
          if line.start_with? id
            "#{id}  ALL=(ALL) NOPASSWD: ALL"
          else
            line
          end
        end
      end
    end

    def save!
      if valid?
        write! sudoers_file
      else
        raise "Sudoers file failed validation.\n#{self}"
      end
    end

    def valid?
      tempfile = Tempfile.new('sudoers')
      write! tempfile.path
      system("sudo visudo -cf #{tempfile.path} > /dev/null 2>&1")
    end

    def to_s
      contents.join("\n").concat("\n")
    end

    def parse_contents
      shell_out! "sudo -p 'Please enter your sudo password: ' true"
      `sudo cat #{sudoers_file}`.split("\n")
    end

    def passwordless_sudo_enabled?(id = '%admin')
      contents.any? {|line| line =~ /^#{id}\s*\w+=\(\w+\)\s+NOPASSWD:/}
    end

    private

    def write!(file)
      shell_out! %Q{printf "%s" '#{self}' | sudo tee #{file} > /dev/null 2>&1}
    end
  end
end