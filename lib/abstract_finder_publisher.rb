class AbstractFinderPublisher
  def initialize(finders, log = true)
    @finders = finders
    @log = log
  end

  def call
    finders.each do |finder|
      publish_if_should(finder)
    end
  end

private
  attr_reader :finders

  def publish_if_should(finder)
    if finder[:metadata].has_key?("content_id") && !preview_only?(finder)
      publish(finder)
    elsif preview_only?(finder)
      if preview_domain_or_not_production?
        publish(finder)
      else
        puts "didn't publish #{finder[:metadata]["name"]} because it is preview_only" if @log
      end
    else
      puts "didn't publish #{finder[:metadata]["name"]} because it doesn't have a content_id" if @log
    end
  end

  def publish(finder)
    raise NotImplementedError
  end

  def preview_only?(finder)
    finder[:metadata]["preview_only"] == true
  end

  def preview_domain_or_not_production?
    ENV.fetch("GOVUK_APP_DOMAIN", "")[/preview/] || !Rails.env.production?
  end
end
