require 'test/unit'
require 'unittest'
require 'field'

class FieldTest < Test::Unit::TestCase
  def test_init
    field = Field.new
    assert_equal(10, field.size)
    assert_equal(10, field.ships.length)
    assert_ships_size_count(field.ships, 1, 4)
    assert_ships_size_count(field.ships, 2, 3)
    assert_ships_size_count(field.ships, 3, 2)
    assert_ships_size_count(field.ships, 4, 1)
    assert_equal(false, field.correct?)
    assert_equal(10, field.incorrect_ships.length)
    assert_equal(false, field.is_fixed?)
    assert_equal(false, field.all_ships_destroyed?)
  end

  def test_locate
    field = Field.new
    field.locate_ships
    assert_equal(true, field.correct?)
    assert_equal(0, field.incorrect_ships.length)
  end
  
  def test_fix
    field = Field.new
    field.locate_ships
    field.fix
    assert_equal(true, field.is_fixed?)
    assert_equal(true, field.ships().all?{ |ship| ship.is_fixed? })
  end
  
  def test_already_fixed
    field = Field.new
    field.locate_ships
    field.fix
    assert_raise TypeError do field.fix end
  end
  
  def test_fix_incorrect_field
    field = Field.new
    # no locate ships
    assert_raise TypeError do field.fix end
  end
  
  def test_strike_target
    field = Field.new
    field.ships.clear
    field.ships.push Ship.new(1, HORIZONTAL, 1, 3)
    field.fix
    result = field.strike_to x=1, y=3
    assert_equal(STRIKE_TARGET, result)
    assert_equal(1, field.strikes.length)
    assert_equal(1, field.strikes.first.x)
    assert_equal(3, field.strikes.first.y)
  end
  
  def test_strike_miss
    field = Field.new
    field.ships.clear
    field.ships.push Ship.new(1, HORIZONTAL, 0, 0)
    field.fix
    result = field.strike_to x=1, y=3
    assert_equal(STRIKE_MISS, result)
    assert_equal(1, field.strikes.length)
    assert_equal(1, field.strikes.first.x)
    assert_equal(3, field.strikes.first.y)
  end
  
  def test_strike_out_of_field
    field = Field.new
    field.locate_ships
    field.fix
    assert_equal(STRIKE_WRONG, field.strike_to(x=1,  y=-2))
    assert_equal(STRIKE_WRONG, field.strike_to(x=-1, y=-2))
    assert_equal(STRIKE_WRONG, field.strike_to(x=11, y=-2))
    assert_equal(STRIKE_WRONG, field.strike_to(x=11, y=2))
    assert_equal(STRIKE_WRONG, field.strike_to(x=11, y=20))
    assert_equal(STRIKE_WRONG, field.strike_to(x=1,  y=20))
    assert_equal(STRIKE_WRONG, field.strike_to(x=-1, y=20))
    assert_equal(STRIKE_WRONG, field.strike_to(x=-1, y=2))
    assert_equal(true, field.strikes.empty?)
  end
  
  def test_strike_in_not_empty_cell
    field = Field.new
    field.ships.clear
    field.ships.push Ship.new(1, HORIZONTAL, 1, 3)
    field.fix
    result = field.strike_to x=1, y=3
    assert_equal(STRIKE_TARGET, result)
    result = field.strike_to x=1, y=3
    assert_equal(STRIKE_WRONG, result)
  end
  
  def test_strike_in_not_fixed_field
    field = Field.new
    # no locate ships
    assert_raise TypeError do field.strike_to x=1, y=2 end
  end
  
  def test_destroy_all_ships
    field = Field.new
    field.locate_ships
    field.fix
    (0..9).each{ |x|
      (0..9).each{ |y| field.strike_to x, y }
    }
    assert_equal true, field.all_ships_destroyed?
  end

  def assert_ships_size_count(ships, ship_size, expect_ships_count)
    actual_ships_count = ships.select{ |ship| ship.size == ship_size }.length
    assert_equal(expect_ships_count, actual_ships_count)
  end
end
