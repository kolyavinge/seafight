require 'utils'

class ShipLocationStrategy
  
  attr_accessor :field_size, :ships
  
  def locate
    check_arguments
    done = try_fix_all_ships
    while not done
      done = try_fix_all_ships
    end
  end

  private

  def try_fix_all_ships
    ships_queue = @ships.clone
    @fixed_ships = []
    while ships_queue.any?
      ship = ships_queue.sample
      return false if not can_fix ship
      @fixed_ships << ship
      ships_queue.delete ship
    end

    return true
  end

  def can_fix ship
    attemp = 10
    while attemp > 0
      x = Random.rand @field_size
      y = Random.rand @field_size
      ship.move_to_x x
      ship.move_to_y y
      ship.rotate if Random.rand(2) == 1
      done = (ship.in_field_with_size? @field_size) && (@fixed_ships.all?{ |fixed_ship| not fixed_ship.impacted?(ship) })
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
