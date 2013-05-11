require 'unittest'
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
  
  def test_player_strike
    game = Game.new
    game.start_battle
    result = game.player_strike_to x=1, y=2
    assert_equal(true, result)
    assert_equal(1, game.player_field.strikes.length)
    assert_equal(1, game.enemy_field.strikes.length)
  end
  
  def test_strike_in_prepare_state
    game = Game.new
    assert_raise TypeError do game.player_strike_to x=1, y=2 end
  end
  
  def test_destroy_all_ships
    game = Game.new
    game.start_battle
    (0..9).each{ |y|
      (0..9).each{ |x| game.player_strike_to x, y if game.state == GAMESTATE_BATTLE }
    }
    assert_equal(true, game.state == GAMESTATE_PLAYER_WIN || game.state == GAMESTATE_ENEMY_WIN)
  end
end
