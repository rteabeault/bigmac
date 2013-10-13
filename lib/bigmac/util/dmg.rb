require 'fileutils'

module BigMac
  class Dmg
    include Mixin::ShellOut

    attr_reader :dmg
    attr_reader :attach_path

    def initialize(dmg)
      @dmg = dmg
    end

    def attach
      cmd = shell_out! %Q{hdiutil attach "#{dmg_path}"}
      cmd.stdout =~ /(\/Volumes\/.*)\n/

      if $1.nil?
        raise "Could not determine path to attached dmg file"
      else
        @attach_path = $1  
      end
    end

    def detach
      unless attach_path.nil?
        shell_out! %Q{hdiutil detach "#{attach_path}"}    
      end
    end

    private

    def dmg_path
      if dmg.kind_of? Proc
        dmg.call
      else
        dmg
      end
    end
  end
end