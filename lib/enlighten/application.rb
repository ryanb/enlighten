class Enlighten::Application
  attr_accessor :trigger
  
  def initialize
    @trigger = trigger
  end
  
  def call(env)
    request = Rack::Request.new(env)
    case request.path
    when /^\/enlighten\/execute/ then execute(request.params["prompt"])
    else render("index.html")
    end
  end
  
  def render(view_file)
    respond_with(erb(view_file))
  end
  
  def respond_with(content)
    [200, {}, [content]]
  end
  
  def execute(command)
    respond_with(eval(command.to_s, @trigger.binding_of_caller).inspect)
  end
  
  def erb(view_file)
    ERB.new(File.read("#{view_path}/#{view_file}.erb")).result(binding)
  end
  
  def view_path
    File.expand_path(File.dirname(__FILE__) + "/views/")
  end
end
