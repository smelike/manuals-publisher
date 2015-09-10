class AbstractFinderPublisher
  def initialize(finders, log = true)
    @finders = finders
    @log = log
  end

  def call
    finders.each do |finder|
      if should_publish_here?(finder)
        publish(finder)
      else
        puts "didn't publish #{finder[:metadata]["name"]} because it is preview_only" if @log
      end
    end
  end

private
  attr_reader :finders

  def publish(finder)
    raise NotImplementedError
  end

  def should_publish_here?(finder)
    publish_everywhere?(finder) || should_publish_preview_only_finders?
  end

  def publish_everywhere?(finder)
    !preview_only?(finder)
  end

  def preview_only?(finder)
    finder[:metadata]["preview_only"] == true
  end

  def should_publish_preview_only_finders?
    ENV.fetch("GOVUK_APP_DOMAIN", "")[/preview/] || !Rails.env.production?
  end
end
