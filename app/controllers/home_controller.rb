class HomeController < ApplicationController
  def index
    @counter = Counter.clicks
    @pending_jobs = Sidekiq::Queue.new.size
  end

  def increment
    IncrementCounterJob.perform_later
    redirect_to root_path, notice: "Job enqueued! Counter will increment in ~2 seconds."
  end

  def ping
    render json: { message: "Pong", timestamp: Time.current.iso8601 }
  end
end
