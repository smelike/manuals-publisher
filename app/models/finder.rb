class Finder
  attr_reader(
    :metadata,
    :schema,
    :timestamp
  )

  def initialize(metadata, schema, timestamp)
    @metadata = metadata
    @schema = schema
    @timestamp = timestamp
  end

  def preview_only?
    metadata["preview_only"] == true
  end

  def has_content_id?
    metadata.has_key?("content_id")
  end
end
