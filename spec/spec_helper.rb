require "rubygems"
require "spec"
require "enlighten_app"

Spec::Runner.configure do |config|
  config.mock_with :rr
end

class MockDebuggerSocket
  attr_reader :buffer
  
  def initialize
    @buffer = []
  end
  
  def puts(content)
  end
  
  def gets
    (@buffer.shift || "PROMPT (rdb:1) ") + "\n"
  end
end
