require 'spec_helper'

describe UtaacDecision do

  def utaac_decision_content_item(n)
    {
      "content_id" => SecureRandom.uuid,
      "base_path" => "/administrative-appeals-tribunal-decisions/example-utaac-decision-#{n}",
      "title" => "Example UTAAC Decision #{n}",
      "description" => "This is the summary of example UTAAC Decision #{n}",
      "format" => "specialist_document",
      "publishing_app" => "specialist-publisher",
      "rendering_app" => "specialist-frontend",
      "locale" => "en",
      "phase" => "live",
      "public_updated_at" => "2015-11-16T11:53:30",
      "publication_state" => "draft",
      "details" => {
        "body" => "## Header" + ("\r\n\r\nThis is the long body of an example UTAAC Decision" * 10),
        "metadata" => {
          "tribunal_decision_category" => "benefits-for-children",
          "tribunal_decision_judges" => "angus-r",
          "tribunal_decision_decision_date" => "2015-07-30",
          "tribunal_decision_sub_category" => "benefits-for-children-benefit-increases-for-children",
          "document_type" => "utaac_decision",
        },
        "change_history" => [],
      },
      "routes" => [
        {
          "path" => "/administrative-appeals-tribunal-decisions/example-utaac-decision-#{n}",
          "type" => "exact",
        }
      ],
      "redirects" => [],
      "update_type" => "major",
    }
  end

  let(:non_utaac_decision_content_item) {
    {
      "content_id" => SecureRandom.uuid,
      "base_path" => "/other-documents/not-a-utaac-tribunal-decision",
      "format" => "specialist_document",
      "details" => {
        "metadata" => {
          "document_type" => "not_a_utaac_decision",
        },
      },
    }
  }

  let(:utaac_decision_org_content_item) {
    {
      "base_path" => "/courts-tribunals/upper-tribunal-administrative-appeals-chamber",
      "content_id" => "4c2e325a-2d95-442b-856a-e7fb9f9e3cf8",
      "title" => "Upper Tribunal (Administrative Appeals Chamber)",
      "format" => "placeholder_organisation",
      "need_ids" => [],
      "locale" => "en",
      "updated_at" => "2015-08-20T10:26:56.082Z",
      "public_updated_at" => "2015-04-15T10:04:28.000+00:00",
      "phase" => "live",
      "analytics_identifier" => "PB1142",
      "links" => {
        "available_translations" => [
          {
            "content_id" => "e9e7fcff-bb0d-4723-af25-9f78d730f6f8",
            "title" => "Administrative appeals tribunal decisions",
            "base_path" => "/administrative-appeals-tribunal-decisions",
            "description" => nil,
            "api_url" => "https://www-origin.integration.publishing.service.gov.uk/api/content/administrative-appeals-tribunal-decisions",
            "web_url" => "https://www-origin.integration.publishing.service.gov.uk/administrative-appeals-tribunal-decisions",
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
      "title" => "Example UTAAC Decision 0",
      "description" => "This is the summary of example UTAAC Decision 0",
      "link" => "/administrative-appeals-tribunal-decisions/example-utaac-decision-0",
      "indexable_content" => "## Header" + ("\r\n\r\nThis is the long body of an example UTAAC Decision" * 10),
      "public_timestamp" => "2015-11-16T11:53:30+00:00",
      "tribunal_decision_category" => "benefits-for-children",
      "tribunal_decision_judges" => "angus-r",
      "tribunal_decision_decision_date" => "2015-07-30",
      "tribunal_decision_sub_category" => "benefits-for-children-benefit-increases-for-children",
      "organisations" => ["upper-tribunal-administrative-appeals-chamber"],
    }
  }

  let(:fields) { %i[base_path content_id] }

  let(:utaac_decisions) { 10.times.map { |n| utaac_decision_content_item(n) } }

  before do
    publishing_api_has_fields_for_format('specialist_document', utaac_decisions, fields)

    utaac_decisions.each do |decision|
      publishing_api_has_item(decision)
    end

    Timecop.freeze(Time.parse("2015-12-18 10:12:26 UTC"))
  end

  describe ".all" do
    it "returns all UTAAC Tribunal Decisions" do
      expect(described_class.all.length).to be(utaac_decisions.length)
    end

    it "rejects any non UTAAC Tribunal Decisions" do
      all_specialist_documents = [non_utaac_decision_content_item] + utaac_decisions
      publishing_api_has_fields_for_format('specialist_document', all_specialist_documents , fields)
      publishing_api_has_item(non_utaac_decision_content_item)

      expect(described_class.all.length).to be(utaac_decisions.length)
    end
  end

  describe ".find" do
    it "returns an UTAAC Tribunal Decision" do
      content_id = utaac_decisions[0]["content_id"]
      utaac_tribunal_decision = described_class.find(content_id)

      expect(utaac_tribunal_decision.base_path).to                        eq(utaac_decisions[0]["base_path"])
      expect(utaac_tribunal_decision.title).to                            eq(utaac_decisions[0]["title"])
      expect(utaac_tribunal_decision.summary).to                          eq(utaac_decisions[0]["description"])
      expect(utaac_tribunal_decision.body).to                             eq(utaac_decisions[0]["details"]["body"])
      expect(utaac_tribunal_decision.tribunal_decision_category).to       eq(utaac_decisions[0]["details"]["metadata"]["tribunal_decision_category"])
      expect(utaac_tribunal_decision.tribunal_decision_decision_date).to  eq(utaac_decisions[0]["details"]["metadata"]["tribunal_decision_decision_date"])
      expect(utaac_tribunal_decision.tribunal_decision_judges).to         eq(utaac_decisions[0]["details"]["metadata"]["tribunal_decision_judges"])
      expect(utaac_tribunal_decision.tribunal_decision_sub_category).to   eq(utaac_decisions[0]["details"]["metadata"]["tribunal_decision_sub_category"])
    end
  end

  describe "#save!" do
    it "saves the UTAAC Tribunal Decision" do
      stub_any_publishing_api_put_content
      stub_any_publishing_api_put_links

      utaac_tribunal_decision = utaac_decisions[0]

      utaac_tribunal_decision.delete("publication_state")
      utaac_tribunal_decision.merge!("public_updated_at" => "2015-12-18T10:12:26+00:00")
      utaac_tribunal_decision["details"].merge!(
        "change_history" => [
          {
            "public_timestamp" => "2015-12-18T10:12:26+00:00",
            "note" => "First published.",
          }
        ]
      )

      c = described_class.find(utaac_tribunal_decision["content_id"])
      expect(c.save!).to eq(true)

      assert_publishing_api_put_content(c.content_id, request_json_includes(utaac_tribunal_decision))
      expect(utaac_tribunal_decision.to_json).to be_valid_against_schema('specialist_document')
    end
  end

  describe "#publish!" do
    it "publishes the UTAAC Tribunal Decision" do
      stub_publishing_api_publish(utaac_decisions[0]["content_id"], {})
      stub_any_rummager_post
      publishing_api_has_fields_for_format('organisation', [utaac_decision_org_content_item], [:base_path, :content_id])

      utaac_tribunal_decision = described_class.find(utaac_decisions[0]["content_id"])
      expect(utaac_tribunal_decision.publish!).to eq(true)

      assert_publishing_api_publish(utaac_tribunal_decision.content_id)
      assert_rummager_posted_item(indexable_attributes)
    end
  end
end
