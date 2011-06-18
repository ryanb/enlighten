require "launchy"

module Enlighten
  module Global
    def enlighten
      require "ruby-debug"
      Debugger.wait_connection = true
      Launchy.open("http://localhost:9090/")
      Debugger.start_remote
      debugger
    end
  end
end

Object.send :include, Enlighten::Global
