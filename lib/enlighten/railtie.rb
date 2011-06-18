module Enlighten
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path("../tasks", __FILE__)
    end
  end
end
