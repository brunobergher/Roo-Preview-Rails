require "test_helper"

class TestimonialsControllerTest < ActionDispatch::IntegrationTest
  test "GET index renders the testimonials page" do
    get testimonials_path
    assert_response :success
    assert_select "h1", "Wall of Love"
  end

  test "POST create with valid params creates testimonial and redirects" do
    assert_difference "Testimonial.count", 1 do
      post testimonials_path, params: { testimonial: { name: "Bob", email: "bob@example.com", city: "NYC", message: "Love this app!" } }
    end
    assert_equal "bob@example.com", Testimonial.last.email
    assert_equal "NYC", Testimonial.last.city
    assert_redirected_to testimonials_path
    follow_redirect!
    assert_match "Thanks for sharing", response.body
  end

  test "POST create with invalid params re-renders form" do
    assert_no_difference "Testimonial.count" do
      post testimonials_path, params: { testimonial: { name: "", message: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "index shows existing testimonials" do
    Testimonial.create!(name: "Charlie", message: "Wonderful experience!")
    get testimonials_path
    assert_match "Charlie", response.body
    assert_match "Wonderful experience!", response.body
  end
end
