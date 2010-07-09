class Enlighten::Application
  attr_accessor :trigger
  
  def initialize
    @trigger = trigger
  end
  
  def call(env)
    render "index.html"
  end
  
  def render(view_file)
    [200, {}, [erb(view_file)]]
  end
  
  def erb(view_file)
    ERB.new(File.read("#{view_path}/#{view_file}.erb")).result(binding)
  end
  
  def view_path
    File.expand_path(File.dirname(__FILE__) + "/views/")
  end
end
