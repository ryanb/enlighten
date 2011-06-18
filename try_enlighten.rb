# Simple script to start a debugger for testing
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

before = true
puts "before"
def foo
  foo = "foo"
  @test = 1
  enlighten
  foo = "bar"
end
foo
after = true
puts "after"
