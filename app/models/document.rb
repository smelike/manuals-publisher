class Document
  include Mongoid::Document

  store_in collection: "specialist_document_editions"

  field :title,        type: String
  field :slug,         type: String
  field :summary,      type: String
  field :body,         type: String
  field :extra_fields, type: Hash, default: {}
  field :state,        type: String

  def facet_options(facet)
    finder_schema.options_for(facet)
  end

  def published?
    state == 'published'
  end

private

  def self.set_extra_field_names(fields)
    fields.each do |field_name|
      define_method(field_name) do
        extra_fields.fetch(field_name, nil)
      end

      define_method((field_name.to_s + "=").to_sym) do |value|
        extra_fields[field_name] = value
      end
    end
  end

  def finder_schema
    @finder_schema ||= FinderSchema.new(document_type)
  end

  def document_type
    "document"
  end
end
