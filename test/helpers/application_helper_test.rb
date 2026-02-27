# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'add returns the sum of two numbers' do
    assert_equal 2, add(1, 1)
  end

  test 'add works with other numbers' do
    assert_equal 5, add(2, 3)
    assert_equal 0, add(-1, 1)
  end
end
