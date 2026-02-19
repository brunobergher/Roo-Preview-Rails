require "test_helper"

class TestimonialsControllerTest < ActionDispatch::IntegrationTest
  MODERN_UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

  test "GET index renders successfully" do
    get testimonials_path, headers: { "User-Agent" => MODERN_UA }
    assert_response :success
    assert_select "h1", "Testimonial Wall"
  end

  test "GET index displays existing testimonials" do
    Testimonial.create!(name: "Alice", body: "Love it!")
    get testimonials_path, headers: { "User-Agent" => MODERN_UA }
    assert_response :success
    assert_select "p", "Love it!"
  end

  test "POST create with valid params creates testimonial and redirects" do
    assert_difference "Testimonial.count", 1 do
      post testimonials_path,
           params: { testimonial: { name: "Bob", body: "Awesome product!" } },
           headers: { "User-Agent" => MODERN_UA }
    end
    assert_redirected_to testimonials_path
    follow_redirect!
    assert_response :success
  end

  test "POST create with invalid params re-renders form" do
    assert_no_difference "Testimonial.count" do
      post testimonials_path,
           params: { testimonial: { name: "", body: "" } },
           headers: { "User-Agent" => MODERN_UA }
    end
    assert_response :unprocessable_entity
  end

  test "POST create with turbo_stream format returns turbo stream" do
    post testimonials_path,
         params: { testimonial: { name: "Carol", body: "Fantastic!" } },
         headers: { "User-Agent" => MODERN_UA },
         as: :turbo_stream
    assert_response :success
    assert_match "turbo-stream", response.body
  end
end
