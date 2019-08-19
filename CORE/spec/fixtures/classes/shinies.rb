class ShinyNewBrick
  def initialize(*args); end
  def method_missing(*args); end
end

class ShinyWorldModule
  def self.world_name
    :shiny_thing
  end
  def initialize(*args); end
  # for intellisense
  def shiny_thing; end
end