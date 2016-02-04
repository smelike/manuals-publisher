module EuropeanStructuralInvestmentFundHelpers
  def create_european_structural_investment_fund(*args)
    create_document(:european_structural_investment_fund, *args)
  end

  def go_to_show_page_for_european_structural_investment_fund(*args)
    go_to_show_page_for_document(:european_structural_investment_fund, *args)
  end

  def check_european_structural_investment_fund_exists_with(*args)
    check_document_exists_with(:european_structural_investment_fund, *args)
  end

  def go_to_european_structural_investment_fund_index
    visit_path_if_elsewhere(european_structural_investment_funds_path)
  end

  def go_to_edit_page_for_european_structural_investment_fund(*args)
    go_to_edit_page_for_document(:european_structural_investment_fund, *args)
  end

  def edit_european_structural_investment_fund(title, *args)
    go_to_edit_page_for_european_structural_investment_fund(title)
    edit_document(title, *args)
  end

  def check_for_new_european_structural_investment_fund_title(*args)
    check_for_new_document_title(:european_structural_investment_fund, *args)
  end

  def withdraw_european_structural_investment_fund(*args)
    withdraw_document(:european_structural_investment_fund, *args)
  end
end
RSpec.configuration.include EuropeanStructuralInvestmentFundHelpers, type: :feature
