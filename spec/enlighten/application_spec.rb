require "spec_helper"

describe Enlighten::Application do
  before(:each) do
    @app = Enlighten::Application.new
    @request = Rack::MockRequest.new(@app)
  end
  
  it "should say not yet enlightened when socket connection fails" do
    stub(TCPSocket).new("localhost", 8989) { raise Errno::ECONNREFUSED }
    @request.get("/").body.should include("Not yet enlightened")
  end
  
  describe "/" do
    before(:each) do
      @app.socket = MockDebuggerSocket.new
      @response = @request.get("/")
    end
    
    it "should render an HTML view" do
      @response.body.should include("<html")
    end
    
    it "should include text input" do
      @response.body.should include("<input")
    end
  end
  
  it "/debugger/eval should evaluate and return response" do
    @app.socket = MockDebuggerSocket.new
    mock(@app.socket).puts("eval chunky")
    @app.socket.buffer << "bacon"
    @request.get("/debugger/eval?code=chunky").body.should == "bacon\n"
  end
end
