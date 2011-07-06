require "spec_helper"

YamlSingleConfig = Configulations.configure do |config|
  config.include_pattern = File.expand_path(".") << "/config/singles/*.yml"
end

JsonSingleConfig = Configulations.configure do |config|
  config.include_pattern = File.expand_path(".") << "/config/singles/*.js*"
end

SingleConfig = Configulations.configure do |config|
  config.include_pattern = File.expand_path(".") << "/config/singles/*.*" #DANGER WILL ROBINSON!
end

describe "Inclusion" do
  describe "yaml" do
    it "finds first and second" do
      YamlSingleConfig.first.name.should == "Leon"
      YamlSingleConfig.second.name.should == "Marc"
      lambda{ YamlSingleConfig.third }.should raise_error
    end
  end

  describe "json" do
    it "finds third and fourth" do
      JsonSingleConfig.third.name.should == "Felix"
      JsonSingleConfig.fourth.name.should == "Mike"
      lambda{ JsonSingleConfig.first }.should raise_error
    end
  end

  describe "mixing json and yml" do
    it "finds eveything" do
      SingleConfig.first.name.should == "Leon"
      SingleConfig.second.name.should == "Marc"
      SingleConfig.third.name.should == "Felix"
      SingleConfig.fourth.name.should == "Mike"
    end
  end
end
