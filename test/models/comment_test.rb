require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    @testimonial = Testimonial.create!(name: "Alice", body: "Great product!")
  end

  test "valid comment" do
    comment = @testimonial.comments.build(author_name: "Bob", body: "I agree!")
    assert comment.valid?
  end

  test "invalid without author_name" do
    comment = @testimonial.comments.build(body: "I agree!")
    assert_not comment.valid?
    assert_includes comment.errors[:author_name], "can't be blank"
  end

  test "invalid without body" do
    comment = @testimonial.comments.build(author_name: "Bob")
    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end

  test "belongs to testimonial" do
    comment = @testimonial.comments.create!(author_name: "Bob", body: "Nice!")
    assert_equal @testimonial, comment.testimonial
  end
end
