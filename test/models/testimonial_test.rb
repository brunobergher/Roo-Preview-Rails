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

  test "name cannot exceed 100 characters" do
    testimonial = Testimonial.new(name: "a" * 101, body: "Hello")
    assert_not testimonial.valid?
  end

  test "body cannot exceed 500 characters" do
    testimonial = Testimonial.new(name: "Alice", body: "a" * 501)
    assert_not testimonial.valid?
  end

  test "recent_first scope orders by created_at desc" do
    old = Testimonial.create!(name: "Old", body: "First", created_at: 2.days.ago)
    new_one = Testimonial.create!(name: "New", body: "Second", created_at: 1.hour.ago)
    assert_equal [new_one, old], Testimonial.recent_first.to_a
  end
end
