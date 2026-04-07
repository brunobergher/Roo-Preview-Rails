require "test_helper"
require "sidekiq/api"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "renders queue size when Redis is available" do
    queue = Object.new
    queue.define_singleton_method(:size) { 3 }

    with_sidekiq_queue(queue) do
      get root_path
    end

    assert_response :success
    assert_includes response.body, "3 jobs queued"
  end

  test "renders homepage when Redis is unavailable" do
    queue = Object.new
    queue.define_singleton_method(:size) do
      raise RedisClient::CannotConnectError, "Redis unavailable"
    end

    with_sidekiq_queue(queue) do
      get root_path
    end

    assert_response :success
    assert_includes response.body, "Queue status unavailable"
  end

  private

  def with_sidekiq_queue(queue)
    sidekiq_queue_class = Sidekiq::Queue.singleton_class

    sidekiq_queue_class.alias_method :__original_new, :new
    sidekiq_queue_class.define_method(:new) { queue }

    yield
  ensure
    sidekiq_queue_class.alias_method :new, :__original_new
    sidekiq_queue_class.remove_method :__original_new
  end
end
