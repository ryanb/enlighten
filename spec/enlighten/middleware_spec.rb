require "spec_helper"

describe Enlighten::Middleware, "simple app" do
  before(:each) do
    app = proc { |e| [200, {}, ["hello"]] }
    middleware = Enlighten::Middleware.new(app)
    @request = Rack::MockRequest.new(middleware)
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
