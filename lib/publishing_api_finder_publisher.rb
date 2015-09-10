require "abstract_finder_publisher"
require "gds_api/publishing_api"
require_relative "../app/presenters/finder_content_item_presenter"
require_relative "../app/presenters/finder_signup_content_item_presenter"

class PublishingApiFinderPublisher < AbstractFinderPublisher

private

  def publish(finder)
    export_finder(finder)
    export_signup(finder) if finder[:metadata].has_key?("signup_content_id")
  end

  def export_finder(finder)
    finder = FinderContentItemPresenter.new(
      finder[:metadata],
      finder[:schema],
      finder[:timestamp],
    )

    attrs = finder.exportable_attributes

    puts "publishing '#{attrs["title"]}' finder" if @log

    publishing_api.put_content_item(finder.base_path, attrs)
  end

  def export_signup(finder)
    finder_signup = FinderSignupContentItemPresenter.new(
      finder[:metadata],
      finder[:timestamp],
    )

    attrs = finder_signup.exportable_attributes

    puts "publishing '#{attrs["title"]}' finder signup page" if @log

    publishing_api.put_content_item(finder_signup.base_path, attrs)
  end

  def publishing_api
    @publishing_api ||= GdsApi::PublishingApi.new(Plek.new.find("publishing-api"))
  end
end
