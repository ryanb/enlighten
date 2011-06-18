require "spec_helper"

describe Enlighten::Application do
  before(:each) do
    @app = Enlighten::Application.new
    @request = Rack::MockRequest.new(@app)
  end

  it "should say not yet enlightened when socket connection fails" do
    TCPSocket.stub(:new).with("localhost", 8989) { raise Errno::ECONNREFUSED }
    @request.get("/").body.should include("Not yet enlightened")
  end

  it "/ should be an html document" do
    @app.debugger = Enlighten::Debugger.new(MockDebuggerSocket.new)
    @request.get("/").body.should include("<html")
  end

  it "/debugger/eval should evaluate and return response" do
    debugger = Enlighten::Debugger.new(MockDebuggerSocket.new)
    @app.debugger = debugger
    debugger.stub(:eval_code).with("chunky") { "bacon" }
    @request.get("/debugger/eval?code=chunky").body.should == "bacon"
  end
end
