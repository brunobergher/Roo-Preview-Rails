class IncrementCounterJob < ApplicationJob
  queue_as :default

  def perform
    sleep 2 # Simulate work / demonstrate async delay
    counter = Counter.clicks
    counter.increment!
    Rails.logger.info "Counter incremented to #{counter.value}"

    Turbo::StreamsChannel.broadcast_replace_to(
      "counter",
      target: "counter_display",
      partial: "home/counter",
      locals: { counter: counter }
    )
  end
end
