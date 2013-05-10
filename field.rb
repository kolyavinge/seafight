require 'ship'

class Field
  
  attr_reader :ships, :size
  
  def self.start_ships
    [Ship.new(1),
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
  
  def initialize
    @size = 10
    @ships = Field.start_ships
  end
  
#  def correct?
#    all_ships_in_field?
#  end
end
