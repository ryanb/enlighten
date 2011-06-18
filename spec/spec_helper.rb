require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require "enlighten_app"

RSpec.configure do |config|
end

class MockDebuggerSocket
  attr_reader :buffer

  def initialize
    @buffer = []
  end

  def puts(content)
  end

  def gets
    @buffer.shift || "PROMPT (rdb:1) \n"
  end
end
