require 'unittest'
require 'ship'
require 'game'

class GameTest < Test::Unit::TestCase
  def test_init
    game = Game.new
    assert_equal(GAMESTATE_PREPARE, game.state)
    assert_equal(true, game.player_field.correct?)
    assert_equal(true, game.enemy_field.correct?)
    assert_equal(false, game.player_field.is_fixed?)
    assert_equal(false, game.enemy_field.is_fixed?)
  end

  def test_start_battle
    game = Game.new
    result = game.start_battle
    assert_equal(true, result)
    assert_equal(GAMESTATE_BATTLE, game.state)
    assert_equal(true, game.player_field.is_fixed?)
    assert_equal(true, game.enemy_field.is_fixed?)
  end

  def test_start_battle_with_incorrect_fields
    game = Game.new
    game.player_field.ships.first.move_to_x -1
    result = game.start_battle
    assert_equal(false, result)
  end

  def test_player_strike_miss
    game = Game.new
    game.enemy_field.ships = [Ship.new(1, HORIZONTAL, 0, 0)]
    game.start_battle
    game.strike_to x=1, y=2
    assert_equal(1, game.enemy_field.strikes.length)
    assert_equal(true, game.player_field.strikes.any?)
  end
  
  def test_player_strike_wrong
    game = Game.new
    game.start_battle
    game.strike_to x=1, y=-2
    assert_equal(0, game.enemy_field.strikes.length)
    assert_equal(0, game.player_field.strikes.length)
  end
  
  def test_player_strike_target
    game = Game.new
    game.enemy_field.ships = [Ship.new(2, HORIZONTAL, 0, 0)]
    game.start_battle
    game.strike_to x=0, y=0
    game.strike_to x=1, y=0
    assert_equal(2, game.enemy_field.strikes.length)
    assert_equal(0, game.player_field.strikes.length)
  end
  
  def test_enemy_strike_target
    game = Game.new
    game.enemy_brain = StubEnemyBrain.new [Point.new(0,0), Point.new(1,0), Point.new(2,0)]
    game.player_field.ships = [Ship.new(3, HORIZONTAL, 0, 0)]
    game.enemy_field.ships = [Ship.new(1, HORIZONTAL, 0, 0)]
    game.start_battle
    game.strike_to x=2, y=3
    assert_equal(1, game.enemy_field.strikes.length)
    assert_equal(3, game.player_field.strikes.length)
  end

  def test_strike_in_prepare_state
    game = Game.new
    assert_raise TypeError do game.strike_to x=1, y=2 end
  end

  def test_destroy_all_ships
    game = Game.new
    game.start_battle
    (0..9).each{ |y|
      (0..9).each{ |x| game.strike_to x, y if game.state == GAMESTATE_BATTLE }
    }
    assert_equal(true, game.state == GAMESTATE_PLAYER_WIN || game.state == GAMESTATE_ENEMY_WIN)
  end
end

class StubEnemyBrain
  attr_accessor :points
  
  def initialize points
    @attemp = 0
    @points = points
  end
  
  def get_strike_point player_field
    @attemp += 1
    return @points[@attemp - 1]
  end
end


