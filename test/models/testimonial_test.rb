require "test_helper"

class TestimonialTest < ActiveSupport::TestCase
  test "valid testimonial" do
    testimonial = Testimonial.new(name: "Alice", message: "This app is fantastic!")
    assert testimonial.valid?
  end

  test "invalid without name" do
    testimonial = Testimonial.new(message: "Great app!")
    assert_not testimonial.valid?
    assert_includes testimonial.errors[:name], "can't be blank"
  end

  test "invalid without message" do
    testimonial = Testimonial.new(name: "Alice")
    assert_not testimonial.valid?
    assert_includes testimonial.errors[:message], "can't be blank"
  end

  test "name cannot exceed 100 characters" do
    testimonial = Testimonial.new(name: "A" * 101, message: "Hello")
    assert_not testimonial.valid?
  end

  test "message cannot exceed 500 characters" do
    testimonial = Testimonial.new(name: "Alice", message: "A" * 501)
    assert_not testimonial.valid?
  end

  test "valid with email" do
    testimonial = Testimonial.new(name: "Alice", email: "alice@example.com", message: "Great!")
    assert testimonial.valid?
  end

  test "valid without email" do
    testimonial = Testimonial.new(name: "Alice", message: "Great!")
    assert testimonial.valid?
  end

  test "invalid with malformed email" do
    testimonial = Testimonial.new(name: "Alice", email: "not-an-email", message: "Great!")
    assert_not testimonial.valid?
    assert_includes testimonial.errors[:email], "must be a valid email address"
  end

  test "valid with city" do
    testimonial = Testimonial.new(name: "Alice", city: "Portland", message: "Great!")
    assert testimonial.valid?
  end

  test "city cannot exceed 100 characters" do
    testimonial = Testimonial.new(name: "Alice", city: "A" * 101, message: "Great!")
    assert_not testimonial.valid?
  end

  test "recent scope orders by created_at desc" do
    old = Testimonial.create!(name: "Old", message: "First", created_at: 2.days.ago)
    new_one = Testimonial.create!(name: "New", message: "Second", created_at: 1.hour.ago)

    assert_equal [new_one, old], Testimonial.recent.to_a
  end
end
