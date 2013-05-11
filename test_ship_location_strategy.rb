require 'unittest'
require 'utils'
require 'field'
require 'ship_location_strategy'

class ShipLocationStrategyTest < Test::Unit::TestCase
  
  include Utils
  
  def setup
    @strategy = ShipLocationStrategy.new
    @strategy.field_size = 10
    @strategy.ships = Field.start_ships
  end

  def test_locate
    @strategy.locate
#    print_field @strategy.ships, 10
    assert_equal 10, @strategy.ships.length
    assert_all_ships_in_field
    assert_no_impacted_ships
  end

  def assert_no_impacted_ships
    impacted_ships = Ship.get_impacted(@strategy.ships).any?
    assert_equal false, impacted_ships, "impacted ships"
  end

  def assert_all_ships_in_field
    all_ships_in_field = @strategy.ships.all?{ |ship| ship.in_field? @strategy.field_size }
    assert_equal true, all_ships_in_field, "out of field ships"
  end
end
