require 'utils'
require 'ship'
require 'field'

GAMESTATE_PREPARE    = 1
GAMESTATE_BATTLE     = 2
GAMESTATE_PLAYER_WIN = 3
GAMESTATE_ENEMY_WIN  = 4

class Game

  attr_reader :player_field, :enemy_field, :state
  
  def initialize
    @state = GAMESTATE_PREPARE
    @player_field = Field.new
    @enemy_field = Field.new
    @player_field.locate_ships
    @enemy_field.locate_ships
  end

  def start_battle
    if @player_field.correct? && @enemy_field.correct?
      @player_field.fix
      @enemy_field.fix
      @state = GAMESTATE_BATTLE
      return true
    else
      return false
    end
  end
  
  def player_strike_to x, y
    raise TypeError.new("battle not started") unless state == GAMESTATE_BATTLE
    
    player_strike_success = @enemy_field.strike_to x, y
    return false unless player_strike_success
    if @enemy_field.all_ships_destroyed?
      @state = GAMESTATE_PLAYER_WIN
      return true
    end
    
    @player_field.strike_to 1, 1
    if @player_field.all_ships_destroyed?
      @state = GAMESTATE_ENEMY_WIN
      return true
    end

    return true
  end
end
