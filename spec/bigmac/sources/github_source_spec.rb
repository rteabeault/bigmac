require 'spec_helper'

module BigMac
  describe GithubSource do
    describe "#download" do
      include FakeFS::SpecHelpers

      let(:github_repo) { "https://github.com/some-org/some-repo" }
      let(:destination) { File.join(BigMac.repositories_dir, 'some-org', 'some-repo') }
      subject { GithubSource.new(github_repo, {}) }

      it "should raise UnaccessibleGithubRepoError if the repository is not accessible" do
        GithubAPI.any_instance.stub(:accessible?).and_return false
        expect { subject.download }.to raise_error UnaccessibleGithubRepoError
      end

      it "should clone the repository if no .bigmac directory exists" do
        GithubAPI.any_instance.stub(:accessible?).and_return true
        GithubAPI.any_instance.should_receive(:download_path).with('.bigmac', destination).and_return {[]}
        Git.stub(:clone) { |url, destination| create_cookbook_project(destination) }

        subject.download.path.should == destination
      end

      it "should use the downloaded .bigmac files if they exist" do
        GithubAPI.any_instance.stub(:accessible?).and_return true
        GithubAPI.any_instance.should_receive(:download_path).with('.bigmac', destination).and_return {
          create_bigmac_project(destination)          
        }

        subject.download.path.should == destination
      end
    end
  end
end
