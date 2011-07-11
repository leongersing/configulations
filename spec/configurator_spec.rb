require "spec_helper"

describe Configulations do
  describe "looks like an object" do
    it "allows for dot-style syntax accessors." do
      c = Configulations.new
      c.development.boo = true
      c.development.boo.should == true
    end

    it "loads yml properties" do
      c = Configulations.new
      c.development.host.should == "localhost"
    end

    it "loads json properties" do
      c = Configulations.new
      c.foo.name.should == 'foo'
    end

    it "loves lazy duck typing" do
      c = Configulations.new
      c.server.content_types.should be_a_kind_of Array
      c.server.content_types.length.should == 3
    end

    it "responds to known booleans." do
      c = Configulations.new
      c.server.cache_enabled?.should == true
      c.server.cache_enabled?.should be_true
    end

    it "is recursive when it needs to be" do
      c = Configulations.new
      c.singles.first.name.should == "Leon"
    end
    
    it "can be used from constants defined in the executing process." do
      MyConfig.should_not be_nil
      MyConfig.root.should_not be_nil
      MyConfig.root.should == "/usr/local/bin/awesome"
    end
  end
end

