require 'ship'

class Field
  
  attr_reader :ships
  
  def initialize
    @ships = [Ship.new(1),
              Ship.new(1),
              Ship.new(1),
              Ship.new(1),
              Ship.new(2),
              Ship.new(2),
              Ship.new(2),
              Ship.new(3),
              Ship.new(3),
              Ship.new(4)]
  end
  
#  def correct?
#    all_ships_in_field?
#  end
  
  def size
    10
  end
end
