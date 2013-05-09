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
end
