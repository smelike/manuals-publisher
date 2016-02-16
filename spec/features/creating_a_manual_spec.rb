require 'spec_helper'

RSpec.feature "Creating a Manual", type: :feature do
  def log_in_as_editor(editor)
    user = FactoryGirl.create(editor)
    GDS::SSO.test_user = user
  end

  let(:manual_content_item) {
    {
      "base_path" => "/guidance/a-manual",
      "content_id" => SecureRandom.uuid,
      "description" => "slkdfj",
      "details" => {
        "body" => "lskdf",
        "child_section_groups" => {
          "title" => "Contents",
          "child_sections" => [ ]
        },
        "change_history" => [ ]
      },
      "format" => "manual",
      "locale" => "en",
      "public_updated_at" => "2016-02-16T1639:44.000Z",
      "publishing_app" => "specialist-publisher",
      "redirects" => [ ],
      "rendering_app" => "specialist-frontend",
      "routes" => [
        {
          "path" => "/guidance/a-manual",
          "type" => "exact"
        }
      ],
      "title" => "A manual",
      "analytics_identifier" => null,
      "phase" => "live",
      "update_type" => null,
      "need_ids" => [ ],
      "publication_state" => "draft",
      "version" => 1
    }
  }

  let(:manual_links) {
    {
      "content_id" => "7794da73-f652-44d5-93d7-9795046c8e93",
      "links" => {
        "organisations" => ["957eb4ec-089b-4f71-ba2a-dc69ac8919ea"]
      }
    }
  }

  before do
    log_in_as_editor(:cma_editor)

    allow(SecureRandom).to receive(:uuid).and_return("7794da73-f652-44d5-93d7-9795046c8e93")
    Timecop.freeze(Time.parse("2015-12-03 16:59:13 UTC"))

    stub_any_publishing_api_put_content
    stub_any_publishing_api_put_links

    publishing_api_has_fields_for_format('manuals', [manual_links], )
    publishing_api_has_item(manual_content_item)
  end


end
