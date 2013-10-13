require 'spec_helper'

module BigMac
  describe Project do
    describe ".from_path" do
      include FakeFS::SpecHelpers

      let(:project_path) { "/someproject" }

      context "when there is a .bigmac directory in the root of the path" do
        before :each do
          FileUtils.mkdir_p("/someproject/.bigmac")
        end
        
        it "should create a BigMacProject" do
          expect(Project.from_path(project_path)).to be_kind_of BigMacProject
        end
      end

      context "when there is a metadata.rb file and a Berksfile in the root of the path" do
        before :each do
          FileUtils.mkdir_p("/someproject/metadata.rb")
          # todo Fix this to be a file
          FileUtils.mkdir_p("/someproject/Berksfile")
        end

        it "should create a CookbookProject" do
          expect(Project.from_path(project_path)).to be_kind_of CookbookProject
        end
      end

      context "when there is just a Berksfile in the root of the path" do
        before :each do
          FileUtils.mkdir_p("/someproject/Berksfile")
        end
        
        it "should create a CookbookRepoProject" do
          expect(Project.from_path(project_path)).to be_kind_of CookbookRepoProject
        end
      end
    end
  end
end