require 'utils'

class ShipLocationStrategy
  
  attr_accessor :field_size, :ships
  
  def locate
    check_arguments
    done = false
    while not done
      done = try_locate_ships
    end
  end

  private

  def try_locate_ships
    ships_queue = @ships.clone
    @located_ships = []
    while ships_queue.any?
      ship = ships_queue.first
      return false if not can_locate ship
      @located_ships << ship
      ships_queue.delete ship
    end

    return true
  end

  def can_locate ship
    attemp = 10
    while attemp > 0
      x, y = Random.rand(@field_size), Random.rand(@field_size)
      ship.move_to_x x
      ship.move_to_y y
      ship.rotate if Random.rand(2) == 1
      done = (ship.in_field? @field_size) && (@located_ships.all?{ |located_ship| not located_ship.impacted? ship })
      return true if done
      attemp -= 1
    end

    return false
  end

  def check_arguments
    raise "field_size not passed" if @field_size == nil
    raise "field_size must be great zero" unless @field_size > 0
    raise "ships not passed" if @ships == nil
    raise "ships is empty" if @ships.empty?
  end
end
