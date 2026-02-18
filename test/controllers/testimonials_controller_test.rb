require "test_helper"

class TestimonialsControllerTest < ActionDispatch::IntegrationTest
  # allow_browser requires either no user-agent or a modern browser version.
  # Sending no User-Agent header bypasses the check entirely.
  setup do
    @headers = { "HTTP_USER_AGENT" => "" }
  end

  test "should get index" do
    get testimonials_url, headers: @headers
    assert_response :success
  end

  test "should create testimonial with valid params" do
    assert_difference("Testimonial.count", 1) do
      post testimonials_url,
        params: { testimonial: { name: "Alice", body: "Love this product!" } },
        headers: @headers
    end
    assert_redirected_to testimonials_path
  end

  test "should not create testimonial with invalid params" do
    assert_no_difference("Testimonial.count") do
      post testimonials_url,
        params: { testimonial: { name: "", body: "" } },
        headers: @headers
    end
    assert_response :unprocessable_entity
  end
end
