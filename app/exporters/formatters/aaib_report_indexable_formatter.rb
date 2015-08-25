require "formatters/abstract_specialist_document_indexable_formatter"

class AaibReportIndexableFormatter < AbstractSpecialistDocumentIndexableFormatter
  def type
    "aaib_report"
  end

private
  def extra_attributes
    {
      aircraft_category: entity.aircraft_category,
      aircraft_category_name: expand_value(:aircraft_category, entity.aircraft_category),
      report_type: entity.report_type,
      report_type_name: expand_value(:report_type, entity.report_type),
      date_of_occurrence: entity.date_of_occurrence,
      location: entity.location,
      aircraft_type: entity.aircraft_type,
      registration: entity.registration,
    }
  end

  def expand_value(key, value)
    SpecialistPublisherWiring.get(:aaib_report_finder_schema).humanized_facet_value(key, value)
  end

  def organisation_slugs
    ["air-accidents-investigation-branch"]
  end
end
