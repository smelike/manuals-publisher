class CmaCase < Document

  set_extra_field_names [
    :opened_date,
    :closed_date,
    :case_type,
    :case_state,
    :market_sector,
    :outcome_type,
  ]

private

  def document_type
    "cma-cases"
  end
end
