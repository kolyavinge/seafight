require 'unittest'
require 'ship'
require 'ship_validator'

class ShipValidatorTest < Test::Unit::TestCase
  
  def test_check_one_normal_ship
    validator = ShipValidator.new()
    validator.field_size = 10
    validator.ships = [Ship.new(3, HORIZONTAL, 2, 3)]
    validator.check
    assert_equal(0, validator.wrong_ships.length)
  end
  
  def test_check_two_normal_ships
    validator = ShipValidator.new()
    validator.field_size = 10
    validator.ships = [Ship.new(3, HORIZONTAL, 2, 3), Ship.new(3, VERTICAL, 5, 5)]
    validator.check
    assert_equal(0, validator.wrong_ships.length)
  end
  
  def test_check_out_of_field
    validator = ShipValidator.new()
    validator.field_size = 10
    validator.ships = [Ship.new(3, VERTICAL, 0, 8)]
    validator.check
    assert_equal(1, validator.wrong_ships.length)
  end
  
  def test_check_two_impacted_ships
    ship1 = Ship.new(3, HORIZONTAL, 0, 0)
    ship2 = Ship.new(4, VERTICAL, 0, 1)
    validator = ShipValidator.new()
    validator.field_size = 10
    validator.ships = [ship1, ship2]
    validator.check
    assert_equal(2, validator.wrong_ships.length)
    assert_equal(true, validator.wrong_ships.include?(ship1))
    assert_equal(true, validator.wrong_ships.include?(ship2))
  end
  
  def test_check_two_impacted_and_out_of_world_ships
    ship1 = Ship.new(3, HORIZONTAL, -2, 0)
    ship2 = Ship.new(4, VERTICAL, 1, 1)
    validator = ShipValidator.new()
    validator.field_size = 10
    validator.ships = [ship1, ship2]
    validator.check
    assert_equal(2, validator.wrong_ships.length)
    assert_equal(true, validator.wrong_ships.include?(ship1))
    assert_equal(true, validator.wrong_ships.include?(ship2))
  end
  
  def test_check_two_crossed_ships
    ship1 = Ship.new(4, HORIZONTAL, 1, 4)
    ship2 = Ship.new(4, VERTICAL, 2, 1)
    validator = ShipValidator.new()
    validator.field_size = 10
    validator.ships = [ship1, ship2]
    validator.check
    assert_equal(2, validator.wrong_ships.length)
    assert_equal(true, validator.wrong_ships.include?(ship1))
    assert_equal(true, validator.wrong_ships.include?(ship2))
  end
end
