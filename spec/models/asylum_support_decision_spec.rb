require 'spec_helper'

describe AsylumSupportDecision do

  def asylum_support_tribunal_decision_content_item(n)
    {
      "content_id" => SecureRandom.uuid,
      "base_path" => "/asylum-support-tribunal-decisions/example-asylum-support-tribunal-decision-#{n}",
      "title" => "Example Asylum Support Tribunal Decision #{n}",
      "description" => "This is the summary of an example Asylum Support Tribunal Decision #{n}",
      "format" => "specialist_document",
      "publishing_app" => "specialist-publisher",
      "rendering_app" => "specialist-frontend",
      "locale" => "en",
      "phase" => "live",
      "public_updated_at" => "2015-11-16T11:53:30",
      "publication_state" => "draft",
      "details" => {
        "body" => "## Header" + ("\r\n\r\nThis is the long body of an example Asylum Support Tribunal Decision" * 10),
        "metadata" => {
          "tribunal_decision_category" => "section-4-1-support-for-persons-who-are-neither-an-asylum-seeker-nor-a-failed-asylum-seeker",
          "tribunal_decision_decision_date" => "2016-02-12",
          "tribunal_decision_judges" => ["Judges name"],
          "tribunal_decision_landmark" => "landmark",
          "tribunal_decision_reference_number" => "12345",
          "tribunal_decision_sub_category" => "section-4-1-bail",
          "document_type" => "asylum_support_decision",
        },
        "change_history" => [],
      },
      "routes" => [
        {
          "path" => "/asylum-support-tribunal-decisions/example-asylum-support-tribunal-decision-#{n}",
          "type" => "exact",
        }
      ],
      "redirects" => [],
      "update_type" => "major",
    }
  end

  let(:non_asylum_support_tribunal_decision_content_item) {
    {
      "content_id" => SecureRandom.uuid,
      "base_path" => "/other-documents/not-an-asylum-support-tribunal-decision",
      "format" => "specialist_document",
      "details" => {
        "metadata" => {
          "document_type" => "not_an_asylum_support_tribunal_decision",
        },
      },
    }
  }

  let(:asylum_support_tribunal_decision_org_content_item) {
    {
      "base_path" => "/courts-tribunals/first-tier-tribunal-asylum-support",
      "content_id" => "7141e343-e7bb-483b-920a-c6a5cf8f758c",
      "title" => "First-tier Tribunal (Asylum Support)",
      "format" => "placeholder_organisation",
      "need_ids" => [],
      "locale" => "en",
      "updated_at" => "2015-08-20T10:26:56.082Z",
      "public_updated_at" => "2015-04-15T10:04:28.000+00:00",
      "phase" => "live",
      "analytics_identifier" => "CO1127",
      "links" => {
        "available_translations" => [
          {
            "content_id" => "581b4bba-e58f-4d07-8e0a-03c8c00165cc",
            "title" => "Asylum support tribunal decisions",
            "base_path" => "/asylum-support-tribunal-decisions",
            "description" => nil,
            "api_url" => "https://www-origin.integration.publishing.service.gov.uk/api/content/asylum-support-tribunal-decisions",
            "web_url" => "https://www-origin.integration.publishing.service.gov.uk/asylum-support-tribunal-decisions",
            "locale" => "en"
          }
        ]
      },
      "description" => nil,
      "details" => {}
    }
  }

  let(:indexable_attributes) {
    {
      "title" => "Example Asylum Support Tribunal Decision 0",
      "description" => "This is the summary of an example Asylum Support Tribunal Decision 0",
      "link" => "/asylum-support-tribunal-decisions/example-asylum-support-tribunal-decision-0",
      "indexable_content" => "## Header" + ("\r\n\r\nThis is the long body of an example Asylum Support Tribunal Decision" * 10),
      "public_timestamp" => "2015-11-16T11:53:30+00:00",
      "tribunal_decision_category" => "section-4-1-support-for-persons-who-are-neither-an-asylum-seeker-nor-a-failed-asylum-seeker",
      "tribunal_decision_decision_date" => "2016/02/12",
      "tribunal_decision_judges" => ["Judges name"],
      "tribunal_decision_landmark" => "landmark",
      "tribunal_decision_reference_number" => "12345",
      "tribunal_decision_sub_category" => "section-4-1-bail",
      "organisations" => ["first-tier-tribunal-asylum-support"],
    }
  }

  before do
    @fields = [
      :base_path,
      :content_id,
    ]

    @asylum_support_tribunal_decisions = []

    10.times do |n|
      @asylum_support_tribunal_decisions << asylum_support_tribunal_decision_content_item(n)
    end

    publishing_api_has_fields_for_format('specialist_document', @asylum_support_tribunal_decisions, @fields)

    @asylum_support_tribunal_decisions.each do |decision|
      publishing_api_has_item(decision)
    end

    Timecop.freeze(Time.parse("2015-12-18 10:12:26 UTC"))
  end

  context "#all" do
    it "returns all Asylum Support Tribunal Decisions" do
      expect(described_class.all.length).to be(@asylum_support_tribunal_decisions.length)
    end

    it "rejects any non Asylum Support Tribunal Decisions" do
      all_specialist_documents = [non_asylum_support_tribunal_decision_content_item] + @asylum_support_tribunal_decisions
      publishing_api_has_fields_for_format('specialist_document', all_specialist_documents , @fields)
      publishing_api_has_item(non_asylum_support_tribunal_decision_content_item)

      expect(described_class.all.length).to be(@asylum_support_tribunal_decisions.length)
    end
  end

  context "#find" do
    it "returns a Asylum Support Tribunal Decision" do
      content_id = @asylum_support_tribunal_decisions[0]["content_id"]
      asylum_support_tribunal_decision = described_class.find(content_id)

      expect(asylum_support_tribunal_decision.base_path).to                          eq(@asylum_support_tribunal_decisions[0]["base_path"])
      expect(asylum_support_tribunal_decision.title).to                              eq(@asylum_support_tribunal_decisions[0]["title"])
      expect(asylum_support_tribunal_decision.summary).to                            eq(@asylum_support_tribunal_decisions[0]["description"])
      expect(asylum_support_tribunal_decision.body).to                               eq(@asylum_support_tribunal_decisions[0]["details"]["body"])
      expect(asylum_support_tribunal_decision.tribunal_decision_category).to         eq(@asylum_support_tribunal_decisions[0]["details"]["metadata"]["tribunal_decision_category"])
      expect(asylum_support_tribunal_decision.tribunal_decision_decision_date).to    eq(@asylum_support_tribunal_decisions[0]["details"]["metadata"]["tribunal_decision_decision_date"])
      expect(asylum_support_tribunal_decision.tribunal_decision_judges).to           eq(@asylum_support_tribunal_decisions[0]["details"]["metadata"]["tribunal_decision_judges"])
      expect(asylum_support_tribunal_decision.tribunal_decision_landmark).to         eq(@asylum_support_tribunal_decisions[0]["details"]["metadata"]["tribunal_decision_landmark"])
      expect(asylum_support_tribunal_decision.tribunal_decision_reference_number).to eq(@asylum_support_tribunal_decisions[0]["details"]["metadata"]["tribunal_decision_reference_number"])
      expect(asylum_support_tribunal_decision.tribunal_decision_sub_category).to     eq(@asylum_support_tribunal_decisions[0]["details"]["metadata"]["tribunal_decision_sub_category"])
    end
  end

  context "#save!" do
    it "saves the Asylum Support Tribunal Decision" do
      stub_any_publishing_api_put_content
      stub_any_publishing_api_put_links

      asylum_support_tribunal_decision = @asylum_support_tribunal_decisions[0]

      asylum_support_tribunal_decision.delete("publication_state")
      asylum_support_tribunal_decision.merge!("public_updated_at" => "2015-12-18T10:12:26+00:00")
      asylum_support_tribunal_decision["details"].merge!(
        "change_history" => [
          {
            "public_timestamp" => "2015-12-18T10:12:26+00:00",
            "note" => "First published.",
          }
        ]
      )

      c = described_class.find(asylum_support_tribunal_decision["content_id"])
      expect(c.save!).to eq(true)

      assert_publishing_api_put_content(c.content_id, request_json_including(asylum_support_tribunal_decision))
      expect(asylum_support_tribunal_decision.to_json).to be_valid_against_schema('specialist_document')
    end
  end

  context "#publish!" do
    it "publishes the Asylum Support Tribunal Decision" do
      stub_publishing_api_publish(@asylum_support_tribunal_decisions[0]["content_id"], {})
      stub_any_rummager_post
      publishing_api_has_fields_for_format('organisation', [asylum_support_tribunal_decision_org_content_item], [:base_path, :content_id])

      asylum_support_tribunal_decision = described_class.find(@asylum_support_tribunal_decisions[0]["content_id"])
      expect(asylum_support_tribunal_decision.publish!).to eq(true)

      assert_publishing_api_publish(asylum_support_tribunal_decision.content_id)
      assert_rummager_posted_item(indexable_attributes)
    end
  end
end
