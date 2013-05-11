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
  end
  
  def correct?
    @ships.all?{ |ship| ship.in_field? @size } && Ship.get_impacted(ships).empty?
  end
  
  def incorrect_ships
    out_of_field = @ships.select{ |ship| not ship.in_field @size }.to_a
    impacted = Ship.get_impacted ships
    out_of_field | impacted
  end
  
  def locate_ships
    location_strategy = ShipLocationStrategy.new
    location_strategy.field_size = @size
    location_strategy.ships = @ships
    location_strategy.locate
  end
end
