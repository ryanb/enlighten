# Simple script to start a debugger for testing
require "rubygems"
require "ruby-debug"
Debugger.wait_connection = true
Debugger.start_remote

before = true
puts "before"
debugger
after = true
puts "after"
