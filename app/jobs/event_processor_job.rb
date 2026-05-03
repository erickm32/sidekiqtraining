class EventProcessorJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find(event_id)
    event.processing!

    Rails.logger.info "[EventProcessorJob] Processing event ##{event.id}: \"#{event.name}\""

    event.update!(status: :processed, processed_at: Time.current)

    Rails.logger.info "[EventProcessorJob] Event ##{event.id} processed at #{event.processed_at}"
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "[EventProcessorJob] Event ##{event_id} not found: #{e.message}"
  end
end
