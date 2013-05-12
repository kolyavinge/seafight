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
    @white_brush = Qt::Brush.new Qt::white
    @grey_brush = Qt::Brush.new Qt::gray
    @red_brush = Qt::Brush.new Qt::red
    @black_pen = Qt::Pen.new Qt::black
    @black_pen.setStyle Qt::SolidLine
  end
  
  def render painter
    # white background
    painter.fillRect @offset_x, @offset_y, @size, @size, @white_brush
    # ships
    if @need_render_ships
      incorrect_ships = @field.incorrect_ships
      @field.ships.each{ |ship| render_ship ship, incorrect_ships, painter }
    end
    # black border
    painter.setPen @black_pen
    painter.drawRect @offset_x, @offset_y, @size, @size
    # grid - horizontal lines
    (1...@field.size).each{ |y| painter.drawLine @offset_x, @offset_y + @cell_size * y, @offset_x + @size, @offset_y + @cell_size * y }
    # grid - vertical lines
    (1...@field.size).each{ |x| painter.drawLine @offset_x + @cell_size * x, @offset_y, @offset_x + @cell_size * x, @offset_y + @size }
  end
  
  private
  
  def render_ship ship, incorrect_ships, painter
    brush = if incorrect_ships.include? ship then @red_brush else @grey_brush end
    ship.coords.each{ |p|
      painter.fillRect @offset_x + p.x * @cell_size, @offset_y + p.y * @cell_size, @cell_size, @cell_size, brush
    }
  end
end
