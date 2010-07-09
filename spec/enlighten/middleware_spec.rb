require "spec_helper"

class WrapperException < Exception
  attr_accessor :original_exception
  def initialize(original_exception)
    @original_exception = original_exception
  end
end

describe Enlighten::Middleware do
  before(:each) do
    @app = nil
    @middleware = Enlighten::Middleware.new(proc { |e| @app.call(e) })
    @request = Rack::MockRequest.new(@middleware)
  end
  
  describe "simple app" do
    before(:each) do
      @app = proc { |e| [200, {}, ["hello"]] }
    end
    
    it "should pass normal requests through without modification" do
      @request.get("/foobar").body.should == "hello"
      @request.get("/foobar/enlighten").body.should == "hello"
    end
    
    it "should not pass enlighten requests through to application" do
      @request.get("/enlighten").body.should_not == "hello"
      @request.get("/enlighten/foo").body.should_not == "hello"
    end
  end
  
  it "with trigger should rescue from exception and return a successful response" do
    @app = proc { |e| raise Enlighten::Trigger }
    @request.get("/foobar").status.should == 200
  end
  
  it "with trigger in wrapper should rescue from exception and return a successful response" do
    @app = proc { |e| raise WrapperException.new(Enlighten::Trigger.new) }
    @request.get("/foobar").status.should == 200
  end
  
  it "with normal exception should not rescue from the exception" do
    @app = proc { |e| raise "normal exception" }
    lambda { @request.get("/foobar") }.should raise_error(RuntimeError)
  end
  
  it "with normal exception in wrapper should not rescue from the exception" do
    @app = proc { |e| raise WrapperException.new(Exception.new) }
    lambda { @request.get("/foobar") }.should raise_error(WrapperException)
  end
  
  it "should default to an enlighten app that has no trigger" do
    @middleware.enlighten_app.trigger.should be_nil
  end
  
  it "should remember enlighten app" do
    @middleware.enlighten_app.should == @middleware.enlighten_app
  end
end
