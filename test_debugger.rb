# Simple script to start a debugger for testing
require "rubygems"
require "ruby-debug"
Debugger.wait_connection = true
Debugger.start_remote

before = true
puts "before"
def foo
  foo = "bar"
  @test = 1
  debugger
  nil
end
foo
after = true
puts "after"
