require "rubygems"
require "spec"
require "rack"
require "enlighten"

Spec::Runner.configure do |config|
  config.mock_with :rr
end
