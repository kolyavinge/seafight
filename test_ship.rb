require 'test/unit'
require 'unittest'
require 'ship'

class ShipTest < Test::Unit::TestCase
  
  def test_default_constructor
    ship = Ship.new(3)
    assert_equal(3, ship.size)
    assert_equal(HORIZONTAL, ship.layout)
    assert_equal(0, ship.x)
    assert_equal(0, ship.y)
  end
  
  def test_constructor
    ship = Ship.new(3, VERTICAL, 3, 4)
    assert_equal(3, ship.size)
    assert_equal(VERTICAL, ship.layout)
    assert_equal(3, ship.x)
    assert_equal(4, ship.y)
  end
  
  def test_coords
    ship = Ship.new(3)
    actual = ship.coords
    expect = [ Point.new(0,0), Point.new(1,0), Point.new(2,0) ]
    assert_equal(expect, actual)
  end
  
  def test_coords_rotated
    ship = Ship.new(3)
    ship.rotate
    expect = [ Point.new(0,0), Point.new(0,1), Point.new(0,2) ]
    assert_equal(expect, ship.coords)
  end
    
  def test_move_by_x
    ship = Ship.new(3)
    ship.move_by_x(2)
    actual = ship.coords
    expect = [ Point.new(2,0), Point.new(3,0), Point.new(4,0) ]
    assert_equal(expect, actual)
  end
  
  def test_move_by_x_negative
    ship = Ship.new(3)
    ship.move_by_x(-2)
    actual = ship.coords
    expect = [ Point.new(-2,0), Point.new(-1,0), Point.new(0,0) ]
    assert_equal(expect, actual)
  end
  
  def test_move_by_y
    ship = Ship.new(3)
    ship.move_by_y(3)
    actual = ship.coords
    expect = [ Point.new(0,3), Point.new(1,3), Point.new(2,3) ]
    assert_equal(expect, actual)
  end
  
  def test_move_by_y_negative
    ship = Ship.new(3)
    ship.move_by_y(-3)
    actual = ship.coords
    expect = [ Point.new(0,-3), Point.new(1,-3), Point.new(2,-3) ]
    assert_equal(expect, actual)
  end
  
  def test_rotate
    ship = Ship.new(4)
    assert_equal(HORIZONTAL, ship.layout)
    ship.rotate
    assert_equal(VERTICAL, ship.layout)
    ship.rotate
    assert_equal(HORIZONTAL, ship.layout)
  end
  
  def test_in_field?
    ship = Ship.new(4)
    assert_equal(true, ship.in_field?(10))
    ship.move_by_y -2
    assert_equal(false, ship.in_field?(10))
  end
  
  def test_impacted
    ship = Ship.new(4)
    assert_equal(true, ship.impacted?(ship))
  end
  
  def test_impacted_1
    ship = Ship.new(4)
    ship1 = Ship.new(4)
    assert_equal(true, ship.impacted?(ship1))
    assert_equal(true, ship1.impacted?(ship))
  end
  
  def test_impacted_2
    ship = Ship.new(4)
    ship1 = Ship.new(4)
    ship1.move_by_y 1
    assert_equal(true, ship.impacted?(ship1))
    assert_equal(true, ship1.impacted?(ship))
  end
  
  def test_impacted_3
    ship = Ship.new(4)
    ship1 = Ship.new(4, VERTICAL, 4, 0)
    assert_equal(true, ship.impacted?(ship1))
    assert_equal(true, ship1.impacted?(ship))
  end
  
  def test_impacted_4
    ship = Ship.new(1, VERTICAL, 4, 4)
    ship1 = Ship.new(3, VERTICAL, 5, 5)
    assert_equal(true, ship.impacted?(ship1))
    assert_equal(true, ship1.impacted?(ship))
  end
  
  def test_check_two_impacted_ships
    ship1 = Ship.new(3, HORIZONTAL, 0, 0)
    ship2 = Ship.new(4, VERTICAL, 0, 1)
    impacted_ships = Ship.get_impacted [ship1, ship2]
    assert_equal(2, impacted_ships.length)
    assert_equal(true, impacted_ships.include?(ship1))
    assert_equal(true, impacted_ships.include?(ship2))
  end
  
  def test_check_two_impacted_and_out_of_world_ships
    ship1 = Ship.new(3, HORIZONTAL, -2, 0)
    ship2 = Ship.new(4, VERTICAL, 1, 1)
    impacted_ships = Ship.get_impacted [ship1, ship2]
    assert_equal(2, impacted_ships.length)
    assert_equal(true, impacted_ships.include?(ship1))
    assert_equal(true, impacted_ships.include?(ship2))
  end
  
  def test_check_two_crossed_ships
    ship1 = Ship.new(4, HORIZONTAL, 1, 4)
    ship2 = Ship.new(4, VERTICAL, 2, 1)
    impacted_ships = Ship.get_impacted [ship1, ship2]
    assert_equal(2, impacted_ships.length)
    assert_equal(true, impacted_ships.include?(ship1))
    assert_equal(true, impacted_ships.include?(ship2))
  end
end
