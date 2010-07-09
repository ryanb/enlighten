require "spec_helper"

describe Enlighten::Trigger do
  def trigger
    something = "foo"
    raise Enlighten::Trigger
  end
  
  it "should contain caller's binding" do
    begin
      trigger
    rescue Enlighten::Trigger => e
      eval("something", e.binding_of_caller).should == "foo"
    end
  end
end
