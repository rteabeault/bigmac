module BigMac

  #   def install_cookbooks(cookbook_path = BigMac.vendor_cookbooks)
  #     unless File.exist?(File.join(@path, 'Berksfile'))
  #       raise "Berksfile not found in repository" 
  #     end

  #     Berks.install(berksfile, cookbook_path)
  #   end

  #   def roles_dir
  #     @roles_dir ||= begin
  #       roles_dir = File.join(@path, 'roles')
  #       if File.exist? roles_dir
  #         roles_dir
  #       end
  #       nil
  #     end
  #   end

  #   def default_role?
  #     @default_role ||= File.exist?(File.join(@path, 'roles', 'default.rb'))
  #   end

  #   def default_runlist
  #     if is_cookbook?
  #       "recipe[#{name}]"
  #     elsif default_role 
  #       "role[default]"
  #     else
  #       nil
  #     end
  #   end

  #   def is_cookbook?
  #     @cookbook ||= File.exist? File.join(@path, 'metadata.rb')
  #   end
  # end

  module Project
    class << self
      def from_path(path)
        klass = klass_from_path(path)
        klass.new(path)
      end

      private

      def klass_from_path(path)
        if contains_bigmac?(path)
          BigMacProject
        elsif contains_metadata?(path) && contains_berksfile?(path)
          CookbookProject
        elsif contains_berksfile?(path)
          CookbookRepoProject
        end 
      end

      def contains_bigmac?(path)
        File.directory?(File.join(path, '.bigmac'))
      end

      def contains_metadata?(path)
        File.exist?(File.join(path, 'metadata.rb'))
      end

      def contains_berksfile?(path)
        File.exist?(File.join(path, 'Berksfile'))
      end
    end

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def default_runlist
      if default_role?
        'role[default]'
      elsif default_recipe?
      end
    end

    def roles_path
      File.join(path, 'roles')
    end

    def default_role?
      File.exist?(File.join(roles_path, 'default.rb'))
    end

    def default_recipe?
      false
    end

    def install_dependencies(to)
      berksfile = File.join(path, 'Berksfile')
      unless File.exist? berksfile
        raise "Berksfile not found in repository" 
      end

      Berks.install(berksfile, to)
    end
  end
end