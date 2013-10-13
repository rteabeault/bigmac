require 'spec_helper'

module BigMac
  describe DmgInstaller do
    describe ".installer" do
      it "should run the OS X installer to install an mpkg" do
        dmg = double(Dmg).as_null_object
        dmg.should_receive(:attach).and_return "/Volumes/Foo"
        dmg.should_receive(:detach)
        Dir.should_receive(:glob).with("/Volumes/Foo/Foo.mpkg").and_return ["/Volumes/Foo/Foo.mpkg"]

        DmgInstaller.should_receive(:shell_out!).with(%Q{sudo installer -pkg "/Volumes/Foo/Foo.mpkg" -target /})
        DmgInstaller.install(dmg, :glob => "Foo.mpkg")
      end

      it "should call detach even if there is an error during the install" do
        dmg = double(Dmg).as_null_object
        dmg.should_receive(:attach).and_return "/Volumes/Foo"
        dmg.should_receive(:detach)
        Dir.should_receive(:glob).with("/Volumes/Foo/Foo.mpkg").and_return ["/Volumes/Foo/Foo.mpkg"]

        DmgInstaller.should_receive(:shell_out!).with(%Q{sudo installer -pkg "/Volumes/Foo/Foo.mpkg" -target /}).and_raise
        
        expect {DmgInstaller.install(dmg, :glob => "Foo.mpkg")}.to raise_error
      end
    end
  end
end