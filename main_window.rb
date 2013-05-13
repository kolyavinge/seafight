# encoding: utf-8

require 'Qt4'
require 'ship'
require 'game'
require 'field_view'

class MainWindow < Qt::Widget
  
  slots 'on_start_game()'

  def initialize
    super
    create_new_game
    @start_button = Qt::PushButton.new 'Начать игру', self do
      move 10, 350
      resize 100, 28
    end
    connect @start_button, SIGNAL('clicked()'), SLOT('on_start_game()')
  end
  
  def create_new_game
    @game = Game.new
    @player_field_view = FieldView.new @game.player_field, 10, 10
    @enemy_field_view = FieldView.new @game.enemy_field, 400, 10, need_render_ships=false
  end

  def showEvent event
    setWindowTitle "Sea Fight on Rubyyyy"
  end
  
  def on_start_game
    if @game.state == GAMESTATE_PREPARE
      if @game.start_battle
        @start_button.setText "Сбросить"
      else
        show_message "Корабли нормально расставь сначала !!!", "Sea fight"
      end
    else
      create_new_game
      @start_button.setText "Начать игру"
      repaint
    end
  end

  def mousePressEvent event
    if @game.state == GAMESTATE_PREPARE
      if mouse_on_player_field? event.pos
        p = global_pos_to_player_field event.pos
        @ship_on_mouse = @game.player_field.ships.find{ |ship| ship.coords.include? p }
        if event.button == Qt::LeftButton
          @last_mouse_pos = event.pos
        elsif event.button == Qt::RightButton && @ship_on_mouse != nil
          @ship_on_mouse.rotate
          repaint
        end
      end
    elsif @game.state == GAMESTATE_BATTLE
      if (event.button == Qt::LeftButton) && (mouse_on_enemy_field? event.pos)
        p = global_pos_to_enemy_field event.pos
        @game.strike_to p.x, p.y
        repaint
        show_end_game_message_if_needed
      end
    end
  end

  def mouseMoveEvent event
    return unless @game.state == GAMESTATE_PREPARE
    if @ship_on_mouse != nil && @last_mouse_pos != nil && mouse_on_player_field?(event.pos)
      old = global_pos_to_player_field @last_mouse_pos
      current = global_pos_to_player_field event.pos
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
  
  def show_end_game_message_if_needed
    if @game.state == GAMESTATE_PLAYER_WIN
      show_message "Победил игрок !", "Конец игры"
    elsif @game.state == GAMESTATE_ENEMY_WIN
      show_message "Победил ботяра !", "Конец игры"
    end
  end

  def mouse_on_player_field? mouse_pos
    mouse_pos.x >= @player_field_view.offset_x &&
    mouse_pos.y >= @player_field_view.offset_y &&
    mouse_pos.x <= @player_field_view.offset_x + @player_field_view.size &&
    mouse_pos.y <= @player_field_view.offset_y + @player_field_view.size
  end
  
  def mouse_on_enemy_field? mouse_pos
    mouse_pos.x >= @enemy_field_view.offset_x &&
    mouse_pos.y >= @enemy_field_view.offset_y &&
    mouse_pos.x <= @enemy_field_view.offset_x + @enemy_field_view.size &&
    mouse_pos.y <= @enemy_field_view.offset_y + @enemy_field_view.size
  end
  
  def global_pos_to_player_field global_pos
    x = (global_pos.x - @player_field_view.offset_x) / @player_field_view.cell_size
    y = (global_pos.y - @player_field_view.offset_y) / @player_field_view.cell_size
    return Point.new(x, y)
  end
  
  def global_pos_to_enemy_field global_pos
    x = (global_pos.x - @enemy_field_view.offset_x) / @enemy_field_view.cell_size
    y = (global_pos.y - @enemy_field_view.offset_y) / @enemy_field_view.cell_size
    return Point.new(x, y)
  end
  
  def show_message message, title
    Qt::MessageBox.new(Qt::MessageBox::Information, title, message).exec
  end
end
