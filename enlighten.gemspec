Gem::Specification.new do |s|
  s.name        = "enlighten"
  s.version     = "0.0.1.alpha"
  s.author      = "Ryan Bates"
  s.email       = "ryan@railscasts.com"
  s.homepage    = "http://github.com/ryanb/enlighten"
  s.summary     = "Debug Ruby through the browser."
  s.description = "A rack application for debugging any Ruby process interactively through the browser."

  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  s.require_path = "lib"

  s.add_dependency 'rack', '~> 1.3.0'
  s.add_dependency 'launchy', '~> 0.4.0'
  s.add_dependency 'ruby-debug19', '~> 0.11.6'

  s.add_development_dependency 'rspec', '~> 2.6.0'

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end
