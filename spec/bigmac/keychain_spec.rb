require 'spec_helper'
require 'ostruct'

module BigMac
  describe GithubKeychain do
    let(:username) { "someuser" }
    let(:password) { "somepassword" }
    let(:check_password_command) { "security find-internet-password -s github.com -r htps" }
    let(:delete_password_command) { "security delete-internet-password -s github.com -r htps -a #{username}" }
    let(:success) { OpenStruct.new(:exitstatus => 0) }
    let(:failure) { OpenStruct.new(:exitstatus => 1) }

    describe "#password_in_keychain?" do
      let(:add_password_command) { "security add-internet-password -s github.com -r htps -a #{username} -w #{password} -T '/usr/libexec/git-core/git-credential-osxkeychain'"}

      it "should return true if the keychain entry exists" do
        GithubKeychain.stub(:shell_out).with(check_password_command).and_return success
        GithubKeychain.password_in_keychain?.should be_true
      end

      it "should return false if the keychain entry does not exist" do
        GithubKeychain.stub(:shell_out).with(check_password_command).and_return failure
        GithubKeychain.password_in_keychain?.should be_false
      end
    end

    describe "#with_password_in_keychain" do
      before :each do
        GithubKeychain.stub(:add_password).with(username, password) { @password_added = true }
        GithubKeychain.stub(:delete_password).with(username, password) { @password_deleted = true }
      end

      context "when the github password is not already in the keychain" do
        before :each do
          GithubKeychain.stub(:password_in_keychain?).and_return false
        end

        it "should add the password, yield and then delete the password" do
          GithubKeychain.with_password_in_keychain(username, password) do
            @password_added.should be_true
          end
          @password_deleted.should be_true
        end
      end

      context "when the github password is already in the keychain" do
        before :each do
          GithubKeychain.stub(:password_in_keychain?).and_return true
        end

        it "should not add the password if it already exists" do
          GithubKeychain.with_password_in_keychain(username, password) do
            @password_added.should be_false
          end
          @password_deleted.should be_false
        end
      end
    end
  end
end