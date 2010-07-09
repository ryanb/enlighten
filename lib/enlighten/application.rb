module Enlighten
  class Application
    attr_reader :trigger
    
    def initialize(trigger = nil)
      @trigger = trigger
    end
    
    def call(env)
      [200, {}, ["triggered"]]
    end
  end
end
