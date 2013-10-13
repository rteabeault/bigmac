require 'spec_helper'
require 'ostruct'

module BigMac
  describe Dmg do
    let(:attach_stdout) { <<-ATTACH.gsub(/^\s+/, "")
      expected   CRC32 $313288DB\n/dev/disk2          
      \tApple_partition_scheme         \t\n/dev/disk2s1        
      \tApple_partition_map            \t\n/dev/disk2s2        
      \tApple_HFS                      \t/Volumes/Command Line Tools (Mountain Lion)\n" 
    ATTACH
    }

    describe "#attach" do
      it "should return the path to the mount point" do
        dmg = Dmg.new("/somepath/some.dmg")
        dmg.should_receive(:shell_out!).with(
          %Q{hdiutil attach "/somepath/some.dmg"}).and_return(
          OpenStruct.new(:stdout => attach_stdout))

        dmg.attach.should == '/Volumes/Command Line Tools (Mountain Lion)'
        dmg.attach_path.should == '/Volumes/Command Line Tools (Mountain Lion)'
      end

      it "should raise error if it can't determine the mount path" do
        dmg = Dmg.new("/somepath/some.dmg")
        dmg.should_receive(:shell_out!).with(
          %Q{hdiutil attach "/somepath/some.dmg"}).and_return(
          OpenStruct.new(:stdout => "some bogus output"))

        expect { dmg.attach }.to raise_error
      end

      context "when path variable is a Proc" do
        it "should call the Proc and use its return value as the path to the dmg file" do
          dmg = Dmg.new(Proc.new { "/somepath/some.dmg" })
          dmg.should_receive(:shell_out!).with(
            %Q{hdiutil attach "/somepath/some.dmg"}).and_return(
            OpenStruct.new(:stdout => attach_stdout))

          dmg.attach
        end
      end
    end

    describe "#detach" do
      it "should detach the mounted volume" do
        dmg = Dmg.new("/somepath/some.dmg")
        dmg.instance_variable_set(:@attach_path, '/Volumes/Foo')
        dmg.should_receive(:shell_out!).with(%Q{hdiutil detach "/Volumes/Foo"})
        dmg.detach
      end

      it "should do nothing if it doesn't know the mount path" do
        dmg = Dmg.new("/somepath/some.dmg")
        dmg.should_not_receive(:shell_out!)
        dmg.detach
      end
    end
  end
end
