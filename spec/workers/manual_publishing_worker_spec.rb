require 'spec_helper'

describe ManualPublishingWorker do
  let(:manual) { Manual.from_publishing_api(Payloads.manual_content_item) }

  it 'should add job to queue' do
    ManualPublishingWorker.perform_async manual.content_id
    expect(ManualPublishingWorker).to have_enqueued_job(manual.content_id)
  end

  it 'should publish a manual' do
    publishing_api_has_item(Payloads.manual_content_item)

    worker = ManualPublishingWorker.new
    worker.perform manual.content_id
    assert_publishing_api_publish(manual.content_id, {})
  end
end
