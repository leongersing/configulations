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
        @config.parent.child.favorite_movie.should == "Empire Strikes Back"
        @config.parent.favorite_movie.should == "Lord of the Rings"
      end

      it "retains non-overwritten options" do
        @config.parent.favorite_actor.should == "Harrison Ford"
      end

      context "environmental overrides." do
        it "accepts the will of ENV specific children" do
          @config.application.host.should == "test.local"
          @config.application.test.host.should == "test.local"
        end

        it "maintains the un-overrided values" do
          @config.application.port.should == 4200
          @config.application.host.should == "test.local"
        end
      end
    end
  end

  describe "Local configuration" do
    before { @config = Configulations.new("./config/local_overrides/") }

    context "So to not leak my personal config, after loading initial config" do
      it "looks in config/local for overrides" do
        @config.local_override_config.basic_local_override.should be_true
      end

      it "respects the non-overridden values" do
        @config.local_override_config.gem_name.should == "Configulations"
      end

      it "supports environmental overrides" do
        @config.local_override_config.environmental_override.should be_true
      end
    end
  end
end

