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
        rescue Enlighten::Trigger => e
          [200, {}, ["triggered #{e.inspect}"]]
        end
      end
    end
  end
end
