require "spec_helper"

describe Enlighten::Application do
  before(:each) do
    @app = Enlighten::Application.new
    @request = Rack::MockRequest.new(@app)
  end
  
  it "should render an HTML view" do
    @request.get("/enlighten").body.should include("<html")
  end
  
  it "should say not yet enlightened" do
    @request.get("/enlighten").body.should include("Not yet enlightened")
  end
  
  describe "with trigger" do
    before(:each) do
      begin
        raise Enlighten::Trigger.new
      rescue Enlighten::Trigger => e
        @app.trigger = e
      end
    end
    
    it "should show text area" do
      @request.get("/enlighten").body.should include("<input")
    end
    
    it "should" do
      @request.post("/enlighten/execute", :params => {"prompt" => "self.class.name"}).body.should == self.class.name.inspect
    end
  end
end
