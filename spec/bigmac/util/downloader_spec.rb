require 'spec_helper'

module BigMac
  describe Downloader do
    describe ".download" do
      it "should curl the url to the cache_dir/file_name by default" do
        destination = File.join(BigMac.cache_dir, 'bar.dmg')
        url = "http://foo.com/somepath/bar.dmg"

        Downloader.should_receive(:shell_out!).with("curl -o #{destination} #{url}")
        Downloader.download(url)
      end

      it "should curl the url to the given destination dir" do
        destination = '/foo/bar.dmg'
        url = "http://foo.com/somepath/something"

        Downloader.should_receive(:shell_out!).with("curl -o #{destination} #{url}")
        Downloader.download(url, '/foo/bar.dmg')
      end
    end
  end
end
