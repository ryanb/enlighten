module Enlighten
  class Middleware
    def initialize(app)
      @app = app
    end
    
    def call(env)
      request = Rack::Request.new(env)
      if (request.path =~ /^\/enlighten/)
        [200, {}, ["enlighten"]]
      else
        begin
          @app.call(env)
        rescue Exception => e
          if e.kind_of?(Trigger) || (e.respond_to?(:original_exception) && e.original_exception.kind_of?(Trigger))
            [200, {}, ["triggered"]]
          else
            raise e
          end
        end
      end
    end
  end
end
