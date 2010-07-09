module Enlighten
  class Middleware
    def initialize(app)
      @external_app = app
    end
    
    def call(env)
      request = Rack::Request.new(env)
      if (request.path =~ /^\/enlighten/)
        enlighten_app.call(env)
      else
        begin
          @external_app.call(env)
        rescue Exception => exception
          app = handle_exception(exception)
          if app
            @enlighten_app = app
            app.call(env)
          else
            raise exception
          end
        end
      end
    end
    
    def enlighten_app
      @enlighten_app ||= Application.new
    end
    
    def handle_exception(exception)
      if exception.kind_of?(Trigger)
        Application.new(exception)
      elsif exception.respond_to?(:original_exception)
        handle_exception(exception.original_exception)
      end
    end
  end
end
