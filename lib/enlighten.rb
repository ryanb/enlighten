module Enlighten
  module Global
    def enlighten
      require "ruby-debug"
      Debugger.wait_connection = true
      Debugger.start_remote
      debugger
    end
  end
end

Object.send :include, Enlighten::Global
