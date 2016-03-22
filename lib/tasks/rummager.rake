
namespace :rummager do
  desc "Publish all Finders to Rummager"
  task :publish_finders => :environment do
    require "rummager_finder_publisher"

    require "multi_json"

    metadatas = Dir.glob("finders/metadata/**/*.json").map do |file_path|
      {
        file: MultiJson.load(File.read(file_path)),
        timestamp: File.mtime(file_path)
      }
    end

    RummagerFinderPublisher.new(metadatas).call
  end

  def document_topics
    {
      "cma-cases" => [
          "competition/competition-act-cartels",
          "competition/consumer-protection",
          "competition/markets",
          "competition/mergers",
          "competition/regulatory-appeals-references"
        ],
      "drug-safety-updates" => [
          "medicines-medical-devices-blood/vigilance-safety-alerts"
        ],
      "medical-safety-alerts" => [
          "medicines-medical-devices-blood/medical-devices-regulation-safety",
          "medicines-medical-devices-blood/vigilance-safety-alerts"
        ],
    }
  end
end
