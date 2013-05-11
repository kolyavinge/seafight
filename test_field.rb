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
  end
  
  def test_locate
    field = Field.new
    field.locate_ships
    assert_equal(true, field.correct?)
  end
  
  def assert_ships_size_count(ships, ship_size, expect_ships_count)
    actual_ships_count = ships.select{ |ship| ship.size == ship_size }.length
    assert_equal(expect_ships_count, actual_ships_count)
  end
end
