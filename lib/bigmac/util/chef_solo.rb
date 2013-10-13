module BigMac
  class ChefSolo
    class << self
      def run(solo_cfg_path, node_file_path)
        shell_out! "/opt/chef/bin/chef-solo -linfo -F doc -c '#{solo_cfg_path}' -j #{node_file_path}", :live_stream => STDOUT
      end  
    end
  end
end