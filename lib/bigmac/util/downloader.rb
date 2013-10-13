require 'fileutils'

module BigMac
  class Downloader
    extend Mixin::ShellOut

    class << self
      def download(url, destination = compute_path(url))
        unless File.exist? destination
          FileUtils.mkdir_p(File.dirname(destination))
          shell_out! "curl -o #{destination} #{url}"
        end
        destination
      end

      private

      def compute_path(url)
        url = URI.parse(url)
        File.join(BigMac.cache_dir, File.basename(url.path))
      end

    end
  end
end