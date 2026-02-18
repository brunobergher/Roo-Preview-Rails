require "test_helper"

class TestimonialTest < ActiveSupport::TestCase
  test "valid testimonial" do
    testimonial = Testimonial.new(name: "Alice", body: "This is great!")
    assert testimonial.valid?
  end

  test "invalid without name" do
    testimonial = Testimonial.new(body: "This is great!")
    assert_not testimonial.valid?
    assert_includes testimonial.errors[:name], "can't be blank"
  end

  test "invalid without body" do
    testimonial = Testimonial.new(name: "Alice")
    assert_not testimonial.valid?
    assert_includes testimonial.errors[:body], "can't be blank"
  end
end
