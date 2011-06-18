module Enlighten
  class Debugger
    def initialize(socket)
      @socket = socket
    end

    def eval_code(code)
      run_command("eval " + code)
    end

    def continue
      run_command("continue")
      @socket.close
    end

    def list
      (run_command("list").split("\n")[1..-1] || []).map do |line|
        pieces = line.scan(/^(\=\>|  ) (\d+)  (.*)/).first
        pieces[0] = (pieces[0] == "=>")
        pieces
      end
    end

    def backtrace
      run_command("backtrace").gsub(/\s*\n\s+at/, " at").split("\n")[0..-2].map do |line|
        pieces = line.scan(/^(\-\-\>|   ) \#(\d+) (.*)/).first || []
        pieces[0] = (pieces[0] == "-->")
        pieces
      end
    end

    def breakpoint(file, line)
      run_command("break #{file}:#{line}")[/\d+/]
    end

    def delete_breakpoint(num = nil)
      run_command(["delete", num].compact.join(" "))
    end

    def next
      run_command("next")
    end

    def step
      run_command("step")
    end

    def local_variables
      run_command("info locals").split("\n").map do |variable|
        variable.split(" = ")
      end
    end

    def instance_variables
      run_command("info instance_variables").split("\n").map do |variable|
        variable.split(" = ")
      end
    end

    def run_command(command)
      @socket.puts(command)
      socket_response
    end

    def socket_response
      continue = true
      response = []
      while continue && line = @socket.gets
        case line
        when /^PROMPT (.*)$/
          continue = false
        when /^CONFIRM (.*)$/
          @socket.puts "y"
        else
          response << line.chomp
        end
      end
      response.join("\n")
    end
  end
end
