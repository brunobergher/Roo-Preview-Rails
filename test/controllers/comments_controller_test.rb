require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @headers = { "HTTP_USER_AGENT" => "" }
    @testimonial = Testimonial.create!(name: "Alice", body: "Great product!")
  end

  test "should create comment with valid params" do
    assert_difference("Comment.count", 1) do
      post testimonial_comments_url(@testimonial),
        params: { comment: { author_name: "Bob", body: "I agree!" } },
        headers: @headers
    end
    assert_redirected_to testimonials_path
  end

  test "should not create comment with invalid params and redirect with alert" do
    assert_no_difference("Comment.count") do
      post testimonial_comments_url(@testimonial),
        params: { comment: { author_name: "", body: "" } },
        headers: @headers
    end
    assert_redirected_to testimonials_path
  end
end
