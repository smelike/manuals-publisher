class CmaCase < Document
<<<<<<< HEAD

  validates :opened_date, allow_blank: true, date: true
  validates :market_sector, presence: true
  validates :case_type, presence: true
  validates :case_state, presence: true
  validates :closed_date, allow_blank: true, date: true

=======
>>>>>>> Add Document and CMA Case model
  FORMAT_SPECIFIC_FIELDS = [
    :opened_date,
    :closed_date,
    :case_type,
    :case_state,
    :market_sector,
    :outcome_type
  ]

  attr_accessor *FORMAT_SPECIFIC_FIELDS

  def initialize(params = {})
    super(params, FORMAT_SPECIFIC_FIELDS)
  end

  def format
    "cma_case"
  end

  def public_path
    "/cma-cases"
  end
<<<<<<< HEAD
=======

  def organisations
    # Org name: Competition And Markets Authority
    ["957eb4ec-089b-4f71-ba2a-dc69ac8919ea"]
  end
>>>>>>> Add Document and CMA Case model
end
