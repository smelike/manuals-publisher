class UtaacDecision < Document
  validates :tribunal_decision_category, presence: true
  validates :tribunal_decision_decision_date, presence: true, date: true
  validates :tribunal_decision_judges, presence: true
  validates :tribunal_decision_sub_category, tribunal_decision_sub_category_relates_to_parent: true

  FORMAT_SPECIFIC_FIELDS = [
    :hidden_indexable_content,
    :tribunal_decision_category,
    :tribunal_decision_decision_date,
    :tribunal_decision_judges,
    :tribunal_decision_sub_category
  ]

  attr_accessor *FORMAT_SPECIFIC_FIELDS

  def initialize(params = {})
    super(params, FORMAT_SPECIFIC_FIELDS)
  end

  def self.publishing_api_document_type
    "utaac_decision"
  end

  def category_prefix_for(category)
    case category
    when "section-95-support-for-asylum-seekers"
      "section-95"
    when "section-4-2-support-for-failed-asylum-seekers"
      "section-4-2"
    when "section-4-1-support-for-persons-who-are-neither-an-asylum-seeker-nor-a-failed-asylum-seeker"
      "section-4-1"
    end
  end
end
