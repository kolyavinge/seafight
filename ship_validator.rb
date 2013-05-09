require 'ship'
require 'utils'

class ShipValidator
  
  attr_accessor :field_size, :ships
  attr_reader :wrong_ships
  
  def check
    check_arguments
    @wrong_ships = ships_not_in_field.concat impacted_ships
    @wrong_ships = @wrong_ships.uniq
  end
  
  private # private methods
  
  def impacted_ships
    result = []
    (0 ... @ships.length-1).each{ |i|
      (i+1 ... @ships.length).each{ |j|
        result << @ships[i] << @ships[j] if impacted? @ships[i], @ships[j]
      }
    }
    raise "result must be array" unless result.is_a? Array
    result
  end
  
  def impacted? ship1, ship2
    ship1.coords.each{ |p1|
      ship2.coords.each{ |p2|
        return true if Utils::impacted_points? p1.x, p1.y, p2.x, p2.y
      }
    }
    
    return false
  end
  
  def ships_not_in_field
    result = @ships.select{ |ship| not in_field? ship }.to_a
    raise "result must be array" unless result.is_a? Array
    result
  end
  
  def in_field? ship
    ship.coords.all?{ |p| p.x >= 0 and p.y >= 0 and p.x < @field_size and p.y < @field_size }
  end
  
  def check_arguments
    raise "field_size not passed" if @field_size == nil
    raise "field_size must be great zero" unless @field_size > 0
    raise "ships not passed" if @ships == nil
    raise "ships is empty" if @ships.empty?
  end
end
