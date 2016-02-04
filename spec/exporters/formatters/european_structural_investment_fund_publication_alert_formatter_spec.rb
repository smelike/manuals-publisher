require "fast_spec_helper"
require "formatters/european_structural_investment_fund_publication_alert_formatter"

RSpec.describe EuropeanStructuralInvestmentFundPublicationAlertFormatter do
  let(:url_maker) {
    double(:url_maker,
      published_specialist_document_path: "http://www.example.com"
    )
  }
  let(:document) {
    double(:document,
      title: "Some title",
      extra_fields: {},
      document_type: "european_structural_investment_fund",
    )
  }
  subject(:formatter) {
    EuropeanStructuralInvestmentFundPublicationAlertFormatter.new(
      document: document,
      url_maker: url_maker,
    )
  }

  it "format should be european_structural_investment_fund" do
    expect(formatter.tags[:format]).to eq(["european_structural_investment_fund"])
  end
end
