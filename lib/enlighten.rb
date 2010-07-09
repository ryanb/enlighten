require "erb"
require "rack"

class Enlighten
  def initialize(app)
    @external_app = app
    @enlighten_app = Application.new
    @static_app = Rack::Static.new(@enlighten_app, :urls => ["/enlighten"], :root => public_path)
  end
  
  def call(env)
    request = Rack::Request.new(env)
    if (request.path =~ /^\/enlighten/)
      @static_app.call(env)
    else
      begin
        @external_app.call(env)
      rescue Exception => exception
        app = handle_exception(exception)
        if app
          app.call(env)
        else
          raise exception
        end
      end
    end
  end
  
  def handle_exception(exception)
    if exception.kind_of?(Trigger)
      @enlighten_app.trigger = exception
      @enlighten_app
    elsif exception.respond_to?(:original_exception)
      handle_exception(exception.original_exception)
    end
  end
  
  def public_path
    File.expand_path(File.dirname(__FILE__) + "/enlighten/public")
  end
end

require "enlighten/trigger"
require "enlighten/application"
