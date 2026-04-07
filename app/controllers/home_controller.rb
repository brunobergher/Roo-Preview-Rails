require "sidekiq/api"

class HomeController < ApplicationController
  def index
    @counter = Counter.clicks
    @pending_jobs = pending_jobs_count
    @secret_sauce = ENV["SECRET_SAUCE"]
  end

  def increment
    IncrementCounterJob.perform_later
    redirect_to root_path, notice: "Job enqueued! Counter will increment in ~2 seconds."
  end

  def ping
    render json: { message: "Pong", timestamp: Time.current.iso8601 }
  end

  private

  def pending_jobs_count
    Sidekiq::Queue.new.size
  rescue RedisClient::ConnectionError
    nil
  end
end
