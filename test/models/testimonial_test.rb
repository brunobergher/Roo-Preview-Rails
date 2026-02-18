require "test_helper"

class TestimonialTest < ActiveSupport::TestCase
  test "valid testimonial" do
    testimonial = Testimonial.new(name: "Alice", body: "This is great!")
    assert testimonial.valid?
  end

  test "valid testimonial with email" do
    testimonial = Testimonial.new(name: "Alice", body: "This is great!", email: "alice@example.com")
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

  test "invalid with malformed email" do
    testimonial = Testimonial.new(name: "Alice", body: "Great!", email: "not-an-email")
    assert_not testimonial.valid?
    assert_includes testimonial.errors[:email], "must be a valid email address"
  end

  test "valid with blank email" do
    testimonial = Testimonial.new(name: "Alice", body: "Great!", email: "")
    assert testimonial.valid?
  end
end
