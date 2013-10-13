require 'spec_helper'

module BigMac
  describe ProjectSource do
    describe ".from_id" do
      let(:id) { nil }
      let(:options) { {} }
      subject { ProjectSource.from_id(id, options) }

      context "when the id is nil" do
        let(:id) { nil }
        it "should create a GithubSource with the default URL" do
          subject.should be_kind_of GithubSource
          subject.url.should == ProjectSource::DEFAULT_REPO_URL
        end
      end

      context "when the id is given in the form of a github user/repo_name" do
        let(:id) { "foo/bar" }
        it "should create a GithubSource with the correct github url" do
          subject.should be_kind_of GithubSource
          subject.url.should eq "https://github.com/foo/bar"
        end
      end

      context "when the id is a full https github url" do
        let(:id) { "https://github.com/foo/bar.git" }
        it "should create a GithubSource with the correct github url" do
          subject.should be_kind_of GithubSource
          subject.url.should eq "https://github.com/foo/bar.git"
        end
      end

      context "when the id is a github readonly url" do
        let(:id) { "git://github.com/rteabeault/bigmac.git" }
        it "should create a repository with the correct github url" do
          subject.should be_kind_of GithubSource
          subject.url.should eq "git://github.com/rteabeault/bigmac.git"
        end
      end

      context "when the id is a github ssh url" do
        let(:id) { "git@github.com:rteabeault/bigmac.git" }
        it "should create a repository with the correct github url" do
          subject.should be_kind_of GithubSource
          subject.url.should eq "git@github.com:rteabeault/bigmac.git"
        end
      end
    end
  end
end
