require "spec_helper"

describe Configurator do
  describe "looks like an object" do
    it "allows for dot-style syntax accessors." do
      c = Configurator.new
      c.development.boo = true
      c.development.boo.should == true
    end

    it "loads yml properties" do
      c = Configurator.new
      c.development.host.should == "localhost"
    end

    it "loads json properties" do
      c = Configurator.new
      c.foo.name.should == 'foo'
    end

    it "loves lazy duck typing" do
      c = Configurator.new
      c.server.content_types.should be_a_kind_of Array
      c.server.content_types.length.should == 3
    end
  end
end

