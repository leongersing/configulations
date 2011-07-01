require "spec_helper"

MyConfig = Configulations.new
MyConfig.root = "/usr/local/bin/awesome"

describe "Sample use" do
  it "just works." do
    MyConfig.should_not be_nil
    MyConfig.root.should_not be_nil
    MyConfig.root.should == "/usr/local/bin/awesome"
  end
end
