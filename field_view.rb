require 'Qt4'

class FieldView

  attr_reader :size, :offset_x, :offset_y, :cell_size
  
  def initialize field, offset_x, offset_y, need_render_ships=true
    @field = field
    @offset_x = offset_x
    @offset_y = offset_y
    @cell_size = 32
    @size = @field.size * @cell_size
    @need_render_ships = need_render_ships
    @white_brush   = Qt::Brush.new(Qt::white)
    @black_brush   = Qt::Brush.new(Qt::black)
    @grey_brush    = Qt::Brush.new(Qt::gray)
    @red_brush     = Qt::Brush.new(Qt::Color.new(255,50,50))
    @darkred_brush = Qt::Brush.new(Qt::Color.new(120,10,10))
    @blue_brush    = Qt::Brush.new(Qt::Color.new(60,170,210))
    @black_pen     = Qt::Pen.new(Qt::black) { setStyle Qt::SolidLine }
  end
  
  def render painter
    # shadow
    painter.fillRect @offset_x+3, @offset_y+3, @size, @size, @black_brush
    # white background
    painter.fillRect @offset_x, @offset_y, @size, @size, @white_brush
    # ships
    if @need_render_ships
      @field.ships.each{ |ship| render_ship ship, painter }
    end
    # strikes
    @field.strikes.each{ |strike| render_strike strike, painter }
    # destroy ships
    @field.destroyed_ships.each{ |ship| render_destroyed_ship ship, painter }
    # black border
    painter.setPen @black_pen
    painter.drawRect @offset_x, @offset_y, @size, @size
    # grid - horizontal lines
    (1...@field.size).each{ |y| painter.drawLine @offset_x, @offset_y + @cell_size * y, @offset_x + @size, @offset_y + @cell_size * y }
    # grid - vertical lines
    (1...@field.size).each{ |x| painter.drawLine @offset_x + @cell_size * x, @offset_y, @offset_x + @cell_size * x, @offset_y + @size }
  end
  
  private
  
  def render_ship ship, painter
    brush = if @field.incorrect_ships.include? ship then @red_brush else @grey_brush end
    ship.coords.each{ |p|
      painter.fillRect @offset_x + p.x * @cell_size, @offset_y + p.y * @cell_size, @cell_size, @cell_size, brush
    }
  end
  
  def render_destroyed_ship ship, painter
    ship.coords.each{ |p|
      painter.fillRect @offset_x + p.x * @cell_size, @offset_y + p.y * @cell_size, @cell_size, @cell_size, @darkred_brush
    }
  end
  
  def render_strike strike, painter
    target = @field.ships.any?{ |ship| ship.coords.include? strike }
    brush = if target then @red_brush else @blue_brush end
    painter.fillRect @offset_x + strike.x * @cell_size, @offset_y + strike.y * @cell_size, @cell_size, @cell_size, brush
  end
end



