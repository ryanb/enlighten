require "rack"
require "fileutils"

namespace :enlighten do
  desc "Start the Enlighten rack server"
  task :start do
    port = 9090
    puts "Starting up Enlighten server on port #{port}"
    FileUtils.mkdir("tmp") unless File.exist? "tmp"
    Rack::Server.start(:Port => port, :pid => "tmp/enlighten.pid", :Host => "0.0.0.0", :config => File.expand_path("../../../config.ru", __FILE__))
  end
end
