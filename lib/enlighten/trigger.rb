module Enlighten
  class Trigger < Exception
    attr_reader :binding_of_caller
    
    # From: http://stackoverflow.com/questions/106920/how-can-i-get-source-and-variable-values-in-ruby-tracebacks
    def initialize
      expected_file, expected_line = caller(1).first.split(':')[0,2]
      expected_line = expected_line.to_i
      return_count = 5

      set_trace_func(proc do |event, file, line, id, binding, kls|
        if file == expected_file && line == expected_line
          @binding_of_caller = binding
          set_trace_func(nil)
        end

        if event == :return
          set_trace_func(nil) if (return_count -= 1) <= 0
        end
      end)
    end
  end
end
