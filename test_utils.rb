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
  
  def test_array_within
    a1 = [1, 2, 3, 4, 5]
    a2 = [2, 4]
    a3 = [1, 2, 666]
    assert_equal(true,  a1.within?(a1))
    assert_equal(true,  a2.within?(a1))
    assert_equal(false, a1.within?(a2))
    assert_equal(false, a3.within?(a1))
    assert_equal(false, a1.within?(a3))
  end
end
