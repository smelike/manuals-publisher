require "abstract_finder_publisher"
require "gds_api/rummager"
require_relative "../app/presenters/finder_rummager_presenter"

class RummagerFinderPublisher < AbstractFinderPublisher

private

  def publish(finder)
    export_finder(finder)
  end

  def export_finder(finder)
    presenter = FinderRummagerPresenter.new(finder[:metadata], finder[:timestamp])
    rummager.add_document(presenter.type, presenter.id, presenter.attributes)
  end

  def rummager
    @rummager ||= GdsApi::Rummager.new(Plek.new.find("rummager"))
  end
end
