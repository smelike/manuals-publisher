require "fast_spec_helper"
require "european_structural_investment_fund"

RSpec.describe EuropeanStructuralInvestmentFund do

  it "is a DocumentMetadataDecorator" do
    doc = double(:document)
    expect(EuropeanStructuralInvestmentFund.new(doc)).to be_a(DocumentMetadataDecorator)
  end

end
