require 'spec_helper'

RSpec.feature "Creating and editing a CMA case", type: :feature, js: true do
  def log_in_as_editor(editor)
    user = FactoryGirl.create(editor)
    GDS::SSO.test_user = user
  end

  before do
    log_in_as_editor(:cma_editor)
  end

  scenario "Create a new CMA case" do
    visit "/cma-cases/new"

    fill_in "Title", with: "Example CMA Case"
    fill_in "Summary", with: "This is the summary of an example CMA case"
    fill_in "Body", with: "## Header" + ("\n\nThis is the long body of an example CMA case" * 10)
    fill_in "Opened date", with: "2014-01-01"
    # fill_in "Market sector", with: "Energy"

    click_button "Save as draft"

    expect(page).to have_success
  end
end
