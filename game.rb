require 'utils'
require 'ship'
require 'field'

GAMESTATE_PREPARE    = 1
GAMESTATE_BATTLE     = 2
GAMESTATE_PLAYER_WIN = 3
GAMESTATE_ENEMY_WIN  = 4

class Game

  attr_reader :player_field, :enemy_field, :state
  attr_accessor :enemy_brain
  
  def initialize
    @state = GAMESTATE_PREPARE
    @player_field = Field.new
    @enemy_field = Field.new
    @player_field.locate_ships
    @enemy_field.locate_ships
    @enemy_brain = RandomEnemyBrain.new
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
  
  def strike_to x, y
    raise TypeError.new("battle not started") unless state == GAMESTATE_BATTLE
    
    player_strike_result = @enemy_field.strike_to x, y
    return if player_strike_result == STRIKE_WRONG
    
    if player_strike_result == STRIKE_TARGET
      if @enemy_field.all_ships_destroyed?
        @state = GAMESTATE_PLAYER_WIN
      end
      return
    end
    
    p = @enemy_brain.get_strike_point @player_field
    while (enemy_strike_result = @player_field.strike_to p.x, p.y) == STRIKE_TARGET
      if @player_field.all_ships_destroyed?
        @state = GAMESTATE_ENEMY_WIN
        return
      end
      p = @enemy_brain.get_strike_point @player_field
    end
  end
end

class RandomEnemyBrain
  def get_strike_point player_field
    point = nil
    done = false
    while not done
      x, y = Random.rand(player_field.size), Random.rand(player_field.size)
      point = Point.new(x, y)
      done = (not player_field.strikes.include? point)
    end
    
    return point
  end
end


