require File.expand_path("../lib/enlighten_app", __FILE__)
run Rack::Static.new(Enlighten::Application.new, :urls => ["/javascripts", "/stylesheets"], :root => File.expand_path("../lib/enlighten/public", __FILE__))
