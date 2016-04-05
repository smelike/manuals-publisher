class ManualPublishingWorker
  include Sidekiq::Worker
  def perform(manual_content_id)
    manual = Manual.find(content_id: manual_content_id)
    manual.publish
  end
end
