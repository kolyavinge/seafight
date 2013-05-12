require 'utils'
require 'ship'
require 'ship_location_strategy'

STRIKE_WRONG  = 1
STRIKE_MISS   = 2
STRIKE_TARGET = 3

class Field
  
  attr_reader   :size, :strikes
  attr_accessor :ships
  
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
    @fixed = false
    @strikes = []
  end
  
  def correct?
    @ships.all?{ |ship| ship.in_field? @size } && Ship.get_impacted(ships).empty?
  end
  
  def incorrect_ships
    out_of_field = @ships.select{ |ship| not ship.in_field? @size }.to_a
    impacted = Ship.get_impacted ships
    out_of_field | impacted
  end
  
  def is_fixed?
    @fixed
  end
  
  def fix
    raise TypeError.new("field already fixed") if @fixed
    raise TypeError.new("field is incorrect")  if not correct?
    @fixed = true
    @ships.each{ |ship| ship.fix }
  end
  
  def strike_to x, y
    raise TypeError.new("can't strike - field not fixed") if not @fixed
    raise "x must integer" unless x.is_a? Integer
    raise "y must integer" unless y.is_a? Integer
    p = Point.new(x, y)
    return STRIKE_WRONG if (x < 0) || (y < 0) || (x >= @size) || (y >= @size) || (@strikes.include? p)
    @strikes << p
    if @ships.any?{ |ship| ship.coords.include? p }
      return STRIKE_TARGET
    else
      return STRIKE_MISS
    end
  end
  
  def all_ships_destroyed?
    @ships.all?{ |ship| ship.coords.within? @strikes }
  end
  
  def destroyed_ships
    @ships.select{ |ship| ship.coords.within? @strikes }.to_a
  end
  
  def locate_ships
    location_strategy = ShipLocationStrategy.new
    location_strategy.field_size = @size
    location_strategy.ships = @ships
    location_strategy.locate
  end
end
