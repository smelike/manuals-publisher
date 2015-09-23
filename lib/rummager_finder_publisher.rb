require "gds_api/rummager"
require_relative "../app/presenters/finder_rummager_presenter"

class RummagerFinderPublisher
  def initialize(metadatas, logger: Logger.new(STDOUT))
    @metadatas = metadatas
    @logger = logger
  end

  def call
    metadatas.each do |metadata|
      if should_publish_in_this_environment?(metadata)
        export_finder(metadata)
      else
        logger.info("didn't publish #{metadata[:file]["name"]} because it is preview_only")
      end
    end
  end

private

  attr_reader :metadatas, :logger

  def should_publish_in_this_environment?(metadata)
    in_preview? || !preview_only?(metadata)
  end

  def preview_only?(metadata)
    metadata[:file]["preview_only"] == true
  end

  def in_preview?
    ENV.fetch("GOVUK_APP_DOMAIN", "")[/preview/] || !Rails.env.production?
  end

  def export_finder(metadata)
    presenter = FinderRummagerPresenter.new(metadata[:file], metadata[:timestamp])
    rummager.add_document(presenter.type, presenter.id, presenter.attributes)
  end

  def rummager
    @rummager ||= GdsApi::Rummager.new(Plek.new.find("rummager"))
  end
end
