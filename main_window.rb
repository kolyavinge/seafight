require 'Qt4'
require 'ship'
require 'game'
require 'field_view'

class MainWindow < Qt::Widget

  def initialize
    super
    @game = Game.new
    @player_field_view = FieldView.new @game.player_field, 10, 10
    @enemy_field_view = FieldView.new @game.enemy_field, 400, 10, need_render_ships=false
  end

  def showEvent event
    setWindowTitle "Sea Fight on Rubyyyy"
  end

  def mousePressEvent event
    if mouse_on_player_field? event.pos
      p = global_pos_to_field event.pos
      @ship_on_mouse = @game.player_field.ships.find{ |ship| ship.coords.include? p }
      if event.button == Qt::LeftButton
        @last_mouse_pos = event.pos
      elsif event.button == Qt::RightButton && @ship_on_mouse != nil
        @ship_on_mouse.rotate
        repaint
      end
    end
  end

  def mouseMoveEvent event
    if @ship_on_mouse != nil && @last_mouse_pos != nil && mouse_on_player_field?(event.pos)
      old = global_pos_to_field @last_mouse_pos
      current = global_pos_to_field event.pos
      dx = current.x - old.x
      dy = current.y - old.y
      @ship_on_mouse.move_by_x dx
      @ship_on_mouse.move_by_y dy
      @last_mouse_pos = event.pos
      repaint
    end
  end

  def mouseReleaseEvent event
    @ship_on_mouse = nil
    @last_mouse_pos = nil
  end

  def paintEvent event
    painter = Qt::Painter.new self
    @player_field_view.render painter
    @enemy_field_view.render painter
    painter.end
  end

  private

  def mouse_on_player_field? mouse_pos
    mouse_pos.x >= @player_field_view.offset_x &&
    mouse_pos.y >= @player_field_view.offset_y &&
    mouse_pos.x <= @player_field_view.offset_x + @player_field_view.size &&
    mouse_pos.y <= @player_field_view.offset_y + @player_field_view.size
  end
  
  def global_pos_to_field global_pos
    x = (global_pos.x - @player_field_view.offset_x) / @player_field_view.cell_size
    y = (global_pos.y - @player_field_view.offset_y) / @player_field_view.cell_size
    return Point.new(x, y)
  end
end
