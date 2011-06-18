require "spec_helper"

describe Enlighten::Debugger do
  before(:each) do
    @socket = MockDebuggerSocket.new
    @debugger = Enlighten::Debugger.new(@socket)
  end

  it "should evaluate and return response" do
    @socket.should_receive(:puts).with("eval chunky")
    @socket.buffer << "bacon\n"
    @debugger.eval_code("chunky").should == "bacon"
  end

  it "should list source code and split into numbered lines" do
    @socket.should_receive(:puts).with("list")
    @socket.buffer << "[8, 10] in test.rb\n   8  \n   9  chunky\n=> 10    bacon\n"
    @debugger.list.should == [[false, "8", ""], [false, "9", "chunky"], [true, "10", "  bacon"]]
  end

  it "list backtrace and point to current one" do
    @socket.should_receive(:puts).with("backtrace")
    @socket.buffer << "--> \#0 Object.foo \n   at line foo.rb:11\n    \#1 at line foo.rb:13\nWarning: ...\n"
    @debugger.backtrace.should == [[true, "0", "Object.foo at line foo.rb:11"], [false, "1", "at line foo.rb:13"]]
  end

  it "delete all breakpoints" do
    @socket.should_receive(:puts).with("delete")
    @debugger.delete_breakpoint
  end

  it "delete a specific breakpoint" do
    @socket.should_receive(:puts).with("delete 123")
    @debugger.delete_breakpoint(123)
  end

  it "delete a specific breakpoint" do
    @socket.should_receive(:puts).with("delete 123")
    @debugger.delete_breakpoint(123)
  end

  it "set breakpoint for a specific file and line" do
    @socket.should_receive(:puts).with("break foo.rb:14")
    @socket.buffer << "Breakpoint 12 file foo.rb, line 14\n"
    @debugger.breakpoint("foo.rb", "14").should == "12"
  end

  it "next should run next command" do
    @socket.should_receive(:puts).with("next")
    @debugger.next
  end

  it "step should run step command" do
    @socket.should_receive(:puts).with("step")
    @debugger.step
  end

  it "should parse out local variables" do
    @socket.should_receive(:puts).with("info locals")
    @socket.buffer << "foo = 123\nchunky = :bacon\n"
    @debugger.local_variables.should == [["foo", "123"], ["chunky", ":bacon"]]
  end

  it "should parse out instance variables" do
    @socket.should_receive(:puts).with("info instance_variables")
    @socket.buffer << "@foo = 123\n@chunky = :bacon\n"
    @debugger.instance_variables.should == [["@foo", "123"], ["@chunky", ":bacon"]]
  end
end
