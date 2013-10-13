require 'spec_helper'

module BigMac
  describe BigMacProject do
    include FakeFS::SpecHelpers

    let(:project_path) { '/someproject' }
    
    subject { BigMacProject.new(project_path) }

    describe "#roles" do
      it "should return an empty array if no roles are present" do
        create_bigmac_project(project_path, [])
        subject.roles.should == []
      end

      it "should return all roles in the roles directory" do
        create_bigmac_project(project_path, [:default, :dev])
        subject.roles.should == ['default', 'dev']
      end
    end    

    describe "#default_runlist" do
      it "should return nil if there is no default role" do
        create_bigmac_project(project_path, [])
        subject.default_runlist.should be_nil
      end

      it "should return role[default] if there is a default role" do
        create_bigmac_project(project_path, [:default])
        subject.default_runlist.should == 'role[default]'
      end
    end 
  end
end