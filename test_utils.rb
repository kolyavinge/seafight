require 'unittest'
require 'utils'

class UtilsTest < Test::Unit::TestCase
 
  def test_impacted_points
    assert_equal(true, Utils::impacted_points?(1, 1, 1, 1))
    assert_equal(true, Utils::impacted_points?(0, 0, 1, 1))
    assert_equal(true, Utils::impacted_points?(0, 1, 1, 1))
    assert_equal(true, Utils::impacted_points?(0, 2, 1, 1))
    assert_equal(true, Utils::impacted_points?(1, 2, 1, 1))
    assert_equal(true, Utils::impacted_points?(2, 2, 1, 1))
    assert_equal(true, Utils::impacted_points?(2, 1, 1, 1))
    assert_equal(true, Utils::impacted_points?(2, 0, 1, 1))
    assert_equal(true, Utils::impacted_points?(1, 0, 1, 1))
  end
  
  def test_not_impacted_points
    assert_equal(false, Utils::impacted_points?(0, 0, 2, 0))
    assert_equal(false, Utils::impacted_points?(0, 0, 2, 2))
    assert_equal(false, Utils::impacted_points?(0, 0, 2, 0))
  end
end
