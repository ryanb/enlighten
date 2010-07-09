require "spec_helper"

describe Enlighten::Application, "with no trigger" do
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
end
