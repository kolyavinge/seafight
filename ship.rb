require 'utils'

#ship layouts
VERTICAL   = 1
HORIZONTAL = 2

class Point
  
  attr_accessor :x, :y
  
  def initialize(x, y)
    raise "x must numeric" unless x.is_a? Numeric
    raise "y must numeric" unless y.is_a? Numeric
    @x, @y = x, y
  end
  
  def to_s
    "(#{@x},#{@y})"
  end
  
  def == (obj)
    @x == obj.x and @y == obj.y
  end
end

class Ship
  
  attr_reader :size, :layout, :x, :y
  
  def initialize(size, layout=HORIZONTAL, x=0, y=0)
    raise "size must integer" unless size.is_a? Integer
    @size = size
    @layout = layout
    @x, @y = x, y
  end
  
  def rotate
    @layout = if @layout == HORIZONTAL then VERTICAL else HORIZONTAL end
  end
  
  def move_by_x(x)
    raise "x must integer" unless x.is_a? Integer
    @x += x
  end
  
  def move_to_x(x)
    raise "x must integer" unless x.is_a? Integer
    @x = x
  end
  
  def move_by_y(y)
    raise "y must integer" unless y.is_a? Integer
    @y += y
  end
  
  def move_to_y(y)
    raise "y must integer" unless y.is_a? Integer
    @y = y
  end
    
  def coords
    if @layout == VERTICAL
      Array.new(@size){ |index| Point.new(@x, @y + index) }
    else
      Array.new(@size){ |index| Point.new(@x + index, @y) }
    end
  end
  
  def in_field_with_size? field_size
    coords.all?{ |p| p.x >= 0 and p.y >= 0 and p.x < field_size and p.y < field_size }
  end
  
  def impacted? other_ship
    coords.each{ |p1|
      other_ship.coords.each{ |p2|
        return true if Utils.impacted_points? p1.x, p1.y, p2.x, p2.y
      }
    }

    return false
  end
  
  def to_s
    coords.to_s
  end
  
  def self.get_impacted_ships ships
    raise "ships not nul" if ships == nil
    result = []
    (0 ... ships.length-1).each{ |i|
      (i+1 ... ships.length).each{ |j|
        ship1, ship2 = ships[i], ships[j]
        result << ship1 << ship2 if ship1.impacted? ship2
      }
    }
    result
  end
end
