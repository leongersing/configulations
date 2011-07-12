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
      raise c.inspect
      c.singles.person_one.name.should == "Leon"
    end

    it "can be used from constants defined in the executing process." do
      MyConfig.should_not be_nil
      MyConfig.root.should_not be_nil
      MyConfig.root.should == "/usr/local/bin/awesome"
    end
  end

  describe "Inheritance" do
    before do
      @config = Configulations.new
    end

    context "when child introduces new config option" do
      it "is appended and namespaced to parent" do
        # config/parent/child.json specifies:
        #   favorite_movie = Empire Strikes Back
        @config.parent.child.favorite_movie.should == "Empire Strikes Back"
      end

      it "retains non-overwritten options" do
        # config/parent/child.json specifies:
        #   favorite_actor = Harrison Ford
        @config.parent.favorite_actor.should == "Harrison Ford"
      end
    end

    context "when child and parent share option" do
      it "overwrites parent config option" do
        # config/parent.json specifies:
        #   favorite_trilogy = Lord of the Rings
        # config/parent/child.json specifies:
        #   favorite_trilogy = Star Wars
        @config.parent.favorite_trilogy.should == "Star Wars"
      end
    end
  end
end

