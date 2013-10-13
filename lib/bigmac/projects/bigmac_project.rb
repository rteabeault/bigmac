module BigMac
  class BigMacProject
    include Project

    def roles_path
      File.join(path, '.bigmac', 'roles')
    end

    def roles
      Dir.glob("#{roles_path}/*.rb").map {|file| (File.basename(file, '.rb'))}
    end

    def default_runlist
      if File.exist? File.join(roles_path, 'default.rb')
        "role[default]" 
      else
        nil
      end
    end

    def default_recipe    
      nil
    end
  end
end