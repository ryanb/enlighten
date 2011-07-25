require "socket"

module Enlighten
  class Application
    attr_accessor :debugger

    def call(env)
      request = Rack::Request.new(env)
      case request.path
      when "/" then render_index
      when /^\/debugger\/(.+)/ then call_debugger($1, request.params)
      else [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
      end
    end

    def call_debugger(command, params)
      case command
      when "eval"
        respond_with(@debugger.eval_code(params["code"]))
      when "continue"
        @debugger.continue
        @debugger = nil
        [302, {'Location'=> '/', 'Content-Type' => 'text/html'}, []]
      else
        raise "Unknown debugger command: #{command}"
      end
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
      if @debugger.nil?
        @debugger = Debugger.new(TCPSocket.new("localhost", 8989))
        @debugger.socket_response # get to first prompt
      end
    rescue Errno::ECONNREFUSED => e
      @debugger = nil
    end
  end
end
