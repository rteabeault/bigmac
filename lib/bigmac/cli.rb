require 'fileutils'

module BigMac
  class CLI < Thor
    include Thor::Actions
    include Mixin::ShellOut

    ALIASES = {
      '--version'  => 'version',
      '-V'         => 'version'
    }

    map ALIASES

    def initialize(*args)
      super(*args)
      @options = options.dup
    end

    class_option :version, 
      :type => :boolean, 
      :aliases => ['-V'],
      :desc => "Show program version"

    desc 'version', 'Display bigmac version.'
    def version
      BigMac.ui.info "#{BigMac.executable_name} #{BigMac::VERSION}"
    end

    option :recipes, :type => :array, :aliases => '-r'
    option :roles, :type => :array, :aliases => '-l'
    option :sudo, :type => :boolean, :default => false, :aliases => '-s'
    option :machine_type, :type => :string, :default => :shared, :aliases => '-m'
    option :private_github, :type => :boolean, :default => false, :aliases => '-p'
    desc 'install <REPOSITORY|RECIPE_NAME>', 'Install a recipe or role'
    def install(id = nil)
      if options[:sudo]
        sudoers = Sudoers.new
        sudoers.add_passwordless_sudo
        sudoers.save!
      end

      if options[:private_github]
        options[:github_username] = BigMac.ui.ask("github username:")
        options[:github_password] = BigMac.ui.ask("github password:", :echo => false)
      end

      Prerequisites.verify

      source = ProjectSource.from_id(id, options)
      Installer.converge(source, BigMac.vendor_cookbooks, options)
    end
  end
end
