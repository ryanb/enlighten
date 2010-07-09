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
        @app.call(env)
      end
    end
  end
end
