require "spec_helper"

# see the spec_helper to see a crazy MyConfig class.
describe "Sample use" do
  it "just works." do
    MyConfig.should_not be_nil
    MyConfig.root.should_not be_nil
    MyConfig.root.should == "/usr/local/bin/awesome"
  end
end
