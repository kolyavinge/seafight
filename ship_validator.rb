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
  
  private
  
  def impacted_ships
    Ship.get_impacted_ships @ships
  end
  
  def ships_not_in_field
    @ships.select{ |ship| not ship.in_field_with_size? @field_size }.to_a
  end

  def check_arguments
    raise "field_size not passed" if @field_size == nil
    raise "field_size must be great zero" unless @field_size > 0
    raise "ships not passed" if @ships == nil
    raise "ships is empty" if @ships.empty?
  end
end
