require 'json/pure'

module BigMac
  class Installer

    class << self
      include Mixin::ShellOut

      def converge(source, cookbook_path, options)
        with_github_in_keychain(options) do 
          project       = source.download
          roles_path    = project.roles_path
          project.install_dependencies(cookbook_path)

          solo_rb = write_solo_rb(cookbook_path, roles_path)
          node_file = write_node_file(options, project.default_runlist)

          ChefSolo.run(solo_rb.path, node_file.path)
        end
      end

      def with_github_in_keychain(options)
        if options[:github_username] && options[:github_password]
          GithubKeychain.with_internet_password(options[:github_username], options[:github_password]) do
            yield
          end
        else
          yield
        end
      end

      def write_solo_rb(cookbook_path, roles_path)
        File.open("#{BigMac.cache_dir}/solo.rb", 'w+') do |file|
          file << solo_rb_contents(cookbook_path, roles_path)
        end
      end

      def write_node_file(options, default_runlist)
        File.open("#{BigMac.cache_dir}/node_file", 'w+') do |file|
          file << node_file_contents(options, default_runlist)
        end
      end

      def solo_rb_contents(cookbook_path, roles_path)
        solo = []
        solo << %Q{file_cache_path  "#{BigMac.cache_dir}"}
        solo << %Q{file_backup_path "#{BigMac.cache_dir}/backup"}
        solo << %Q{cache_options(:path => "#{BigMac.cache_dir}/checksums", :skip_expires => true)}
        solo << %Q{cookbook_path ["#{cookbook_path}"]}
        solo << %Q{role_path ["#{roles_path}"]} if roles_path
        solo.join("\n")
      end

      def node_file_contents(options, default_runlist)
        run_list = []
        options[:recipes].each { |recipe| run_list << "recipe[#{recipe}]" }
        options[:roles].each { |recipe| run_list << "role[#{recipe}]" }

        run_list << default_runlist if run_list.empty?

        JSON.generate({
          "run_list" => run_list
        })
      end
    end
  end
end