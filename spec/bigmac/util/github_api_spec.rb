require 'spec_helper'

module BigMac
  describe GithubAPI do
    include FakeFS::SpecHelpers

    subject { GithubAPI.from_url url, options}
    let(:url) { "https://github.com/rteabeault/bigmac-test" }
    let(:options) { {} }

    describe ".from_url" do

      it "should build the api_url correctly" do
        subject.instance_variable_get(:@api_url).should == 
          "https://api.github.com/repos/rteabeault/bigmac-test"
      end

      context "when githbub credentials are provided" do
        let(:options) {{:github_username => "lion", :github_password => "fur"}}
        it "should build the api_url correctly" do
          subject.instance_variable_get(:@api_url).should == 
            "https://lion:fur@api.github.com/repos/rteabeault/bigmac-test"
        end
      end
    end

    describe "#download_path" do
      let(:api_url) { "https://api.github.com/repos/rteabeault/bigmac-test" }
      let(:path_url) { "#{api_url}/contents/.bigmac" }
      let(:berksfile) { {'type' => 'file', 'path' => '.bigmac/Berksfile'} }
      let(:readme) { {'type' => 'file', 'path' => '.bigmac/README.md'} }
      let(:roles_dir) { {'type' => 'dir', 'path' => '.bigmac/roles'} }
      let(:roles_url) { "#{api_url}/contents/.bigmac/roles" }
      let(:default_role) { {'type' => 'file', 'path' => '.bigmac/roles/default.rb'} }

      it "should handle a path which contains a single file" do
        stub_http_request(:get, path_url).to_return(:body => JSON.generate([berksfile]))
        subject.find_files(".bigmac").should == [berksfile]
      end

      it "should handle a path which contains multiple files" do
        stub_http_request(:get, path_url).to_return(:body => JSON.generate([berksfile, readme]))
        subject.find_files(".bigmac").should == [berksfile, readme]
      end

      it "should handle a path which contains a subdirectory" do
        stub_http_request(:get, path_url).to_return(:body => JSON.generate([berksfile, readme, roles_dir]))
        stub_http_request(:get, roles_url).to_return(:body => JSON.generate([default_role]))
        subject.find_files(".bigmac").should == [berksfile, readme, default_role]
      end
    end
  end
end