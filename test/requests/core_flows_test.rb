require "test_helper"
require "active_job/test_helper"
require "time"

class CoreFlowsTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @original_queue_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    clear_enqueued_jobs
    clear_performed_jobs
  end

  teardown do
    clear_enqueued_jobs
    clear_performed_jobs
    ActiveJob::Base.queue_adapter = @original_queue_adapter
  end

  test "GET / responds successfully" do
    counter = Counter.clicks

    get root_path

    assert_response :success
    assert_select "h1", text: "Hello, World!"
    assert_select "#counter_display", text: /\b#{counter.value}\b/
  end

  test "GET /ping returns the current pong payload" do
    get ping_path

    assert_response :success
    assert_equal "application/json", response.media_type

    payload = response.parsed_body

    assert_equal "Pong", payload["message"]
    assert Time.iso8601(payload["timestamp"])
  end

  test "POST /increment redirects home and enqueues the increment job" do
    counter = Counter.clicks
    counter.update!(value: 7)

    assert_no_changes -> { counter.reload.value } do
      assert_enqueued_with(job: IncrementCounterJob) do
        post increment_path
      end
    end

    assert_redirected_to root_path

    follow_redirect!

    assert_response :success
    assert_match "Job enqueued! Counter will increment in ~2 seconds.", response.body
    assert_select "#counter_display", text: /\b7\b/
  end
end
