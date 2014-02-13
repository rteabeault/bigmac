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
      BigMac.ui.debug = true if @options["debug"]
    end

    class_option :version,
      :type => :boolean,
      :aliases => ['-V'],
      :desc => "Show program version"

    class_option :debug,
      :type => :boolean,
      :aliases => ['-d'],
      :desc => "Print debug information"

    desc 'version', 'Display bigmac version.'
    def version
      BigMac.ui.info "#{BigMac.executable_name} #{BigMac::VERSION}"
    end

    option :recipes, :type => :array, :aliases => '-r', :default => []
    option :roles, :type => :array, :aliases => '-l', :default => []
    option :sudo, :type => :boolean, :default => false, :aliases => '-s'
    option :machine_type, :type => :string, :default => :shared, :aliases => '-m'
    option :private_github, :type => :boolean, :default => false, :aliases => '-p'
    desc 'install <REPOSITORY|RECIPE_NAME>', 'Install a recipe or role'
    def install(id = nil)

      if options[:sudo]
        # Prompt for sudo password and then
        # Revalidate sudo in a thread via sudo -v
      end

      if options[:private_github]
        options[:github_username] = BigMac.ui.ask("github username:")
        options[:github_password] = BigMac.ui.ask("github password:", :echo => false)
      end

      os = OS.current
      os.install_prerequisites!

      # source = ProjectSource.from_id(id, options)
      # Installer.converge(source, BigMac.vendor_cookbooks, options)
    end
  end
end
