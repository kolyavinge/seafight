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
  
  def move_by_y(y)
    raise "y must integer" unless y.is_a? Integer
    @y += y
  end
    
  def coords
    if @layout == VERTICAL
      Array.new(@size){ |index| Point.new(@x, @y + index) }
    else
      Array.new(@size){ |index| Point.new(@x + index, @y) }
    end
  end
end
