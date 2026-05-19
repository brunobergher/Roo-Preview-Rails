require "test_helper"

class HomeThemeTest < ActionDispatch::IntegrationTest
  test "home page applies the project theme" do
    get root_url

    assert_response :success
    assert_select "body.bg-red-500.font-times.grayscale-images"
    assert_select "h1.font-times", text: "Hello, World!"
  end
end
