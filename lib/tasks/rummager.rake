
namespace :rummager do
  desc "Publish all Finders to Rummager"
  task :publish_finders do
    require "rummager_finder_publisher"

    require "multi_json"

    finder_loader = PublishingApiFinderLoader.new('finders')

    RummagerFinderPublisher.new(finder_loader.finders).call
  end
end
