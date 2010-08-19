module Enlighten
  class Application
    attr_accessor :socket
    
    def call(env)
      request = Rack::Request.new(env)
      case request.path
      when "/" then render_index
      when /^\/debugger\/(.+)/ then call_debugger($1, request.params)
      else [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
      end
    end
    
    def call_debugger(command, params)
      @socket.puts command + " " + params["code"]
      respond_with(socket_response)
    end
    
    def render_index
      connect_to_debugger
      render("index.html")
    end
    
    def render(view_file)
      respond_with(erb(view_file))
    end
    
    def respond_with(content)
      [200, {"Content-Type" => "text/html"}, [content]]
    end
    
    def erb(view_file)
      ERB.new(File.read("#{view_path}/#{view_file}.erb")).result(binding)
    end
    
    def view_path
      File.expand_path(File.dirname(__FILE__) + "/views/")
    end
    
    def connect_to_debugger
      if @socket.nil?
        @socket = TCPSocket.new("localhost", 8989)
        socket_response # get to first prompt
      end
    rescue Errno::ECONNREFUSED => e
      @socket = nil
    end
    
    def socket_response
      continue = true
      response = []
      while continue && line = @socket.gets
        print line
        case line 
        when /^PROMPT (.*)$/
          continue = false
        when /^CONFIRM (.*)$/
          socket.puts "y"
        else
          response << line
        end
      end
      response.join
    end
  end
end
