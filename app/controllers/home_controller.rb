class HomeController < ApplicationController
  def index
    @counter = Counter.clicks
    @pending_jobs = Sidekiq::Queue.new.size
  end

  def increment
    IncrementCounterJob.perform_later
    redirect_to root_path, notice: "Job enqueued! Counter will increment in ~2 seconds."
  end
end
