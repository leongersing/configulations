require "./magic_hash"

describe(MagicHash) do
  describe("what makes it magical...") do
    it "gives dot syntax to Hash." do
      options ={:foo => "bar"}
      options.extend(MagicHash)
      options.foo.should == "bar"
    end

    it "is a hash when asked." do
      options ={:foo => "bar"}
      options.extend(MagicHash)
      options.kind_of?(Hash).should == true
      options.is_a?(Hash).should == true
    end

  end
end