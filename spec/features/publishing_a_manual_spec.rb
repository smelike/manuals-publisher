require 'spec_helper'

RSpec.feature "Publishing a manual", type: :feature do
  let(:manual_content_item) { Payloads.manual_content_item }
  let(:content_id) { manual_content_item['content_id'] }
  let(:manual_links) { Payloads.manual_links }
  let(:section_content_items) { Payloads.section_content_items }
  let(:section_links) { Payloads.section_links }
  let(:sections_content_ids) do
    section_content_items.map { |section| section["content_id"] }
  end

  before do
    log_in_as_editor(:gds_editor)

    publishing_api_has_fields_for_document("manual", [manual_content_item], [:content_id])
    publishing_api_has_fields_for_document("manual_section", section_content_items.map { |section| { content_id: section["content_id"] } }, [:content_id])

    content_items = [manual_content_item] + section_content_items

    content_items.each do |payload|
      publishing_api_has_item(payload)
    end

    links = [manual_links] + section_links

    links.each do |link_set|
      publishing_api_has_links(link_set)
    end

    stub_publishing_api_publish(content_id, {})
    stub_publishing_api_publish(sections_content_ids[0], {})
    stub_publishing_api_publish(sections_content_ids[1], {})
  end

  scenario "from manuals index" do
    visit "/manuals"
    expect(page.status_code).to eq(200)

    click_link "A Manual"
    expect(page.status_code).to eq(200)

    expect(page).to have_content("A Manual")

    click_button "Publish"

    assert_publishing_api_publish(content_id)
    assert_publishing_api_publish(sections_content_ids[0])
    assert_publishing_api_publish(sections_content_ids[1])

    expect(page).to have_content("Published A Manual")
    expect(page.status_code).to eq(200)
  end
end
