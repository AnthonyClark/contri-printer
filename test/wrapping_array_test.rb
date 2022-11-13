require 'minitest/autorun'
require 'wrapping_array'

class WrappingArrayTest < Minitest::Test
  def test_wrapping
    array = WrappingArray.new([1, 2, 3])

    assert_equal(1, array[0])
    assert_equal(2, array[1])
    assert_equal(3, array[2])
    assert_equal(1, array[3])
    assert_equal(3, array[-1])
  end

  def test_wrapping_2D_cols
    array = WrappingArray.new( 3 ) { WrappingArray.new([1, 2, 3]) }

    assert_equal(1, array[0][0])
    assert_equal(2, array[0][1])
    assert_equal(3, array[0][2])
    assert_equal(1, array[0][3])
    assert_equal(3, array[0][-1])
  end

  def test_wrapping_2D_rows
    array = WrappingArray.new(3) { |i|  WrappingArray.new([i, i*2, i*3]) }

    assert_equal(0, array[0][0])
    assert_equal(1, array[1][0])
    assert_equal(2, array[2][0])
    assert_equal(0, array[3][0])
    assert_equal(2, array[-1][0])
  end
end
