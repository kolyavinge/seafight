require 'ship'
require 'ship_location_strategy'

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
    #locate_all_ships
  end
  
#  def correct?
#    all_ships_in_field?
#  end
  private
  
  def locate_all_ships
    location_strategy = ShipLocationStrategy.new
    location_strategy.field_size = @size
    location_strategy.ships = @ships
    location_strategy.locate
  end
end
