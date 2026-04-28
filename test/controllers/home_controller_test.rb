require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "root page uses the rainbow background" do
    get root_url

    assert_response :success
    assert_includes response.body, "rainbow-cycle-bg"
  end
end
