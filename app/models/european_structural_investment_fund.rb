require "document_metadata_decorator"

class EuropeanStructuralInvestmentFund < DocumentMetadataDecorator
  set_extra_field_names [
    :fund_state,
    :fund_type,
    :location,
    :funding_source,
    :closing_date,
  ]
end
