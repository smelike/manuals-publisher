require "url_maker"
require "rummager_indexer"
require "publishing_api_withdrawer"
require "formatters/specialist_document_publishing_api_formatter"

class AbstractSpecialistDocumentObserversRegistry
  def initialize(organisation_content_ids)
    @organisation_content_ids = organisation_content_ids
  end

  def creation
    [
      publishing_api_exporter,
    ]
  end

  def update
    [
      publishing_api_exporter,
    ]
  end

  def publication
    [
      publication_logger,
      publishing_api_exporter,
      rummager_exporter,
      publication_alert_exporter,
    ]
  end

  def republication
    [
      publishing_api_exporter,
      rummager_exporter,
    ]
  end

  def draft_republication
    [
      publishing_api_exporter,
    ]
  end

  def withdrawn_republication
    [
      publishing_api_exporter(true),
      publishing_api_draft_unpublisher,
    ]
  end

  def withdrawal
    [
      publishing_api_withdrawer,
      rummager_withdrawer,
    ]
  end

private
  attr_reader :organisation_content_ids

  def publishing_api_exporter(force_draft = false)
    ->(document, update_type = nil) {
      rendered_document = SpecialistDocumentPublishingAPIFormatter.new(
        document,
        specialist_document_renderer: ManualsPublisherWiring.get(:specialist_document_renderer),
        publication_logs: PublicationLog,
        links: format_links_for_publishing_api(document),
        update_type: update_type
      )

      SpecialistDocumentPublishingAPIExporter.new(
        publishing_api,
        rendered_document,
        force_draft || document.draft?
      ).call
    }
  end

  def publishing_api_withdrawer
    ->(document) {
      PublishingAPIWithdrawer.new(
        publishing_api: publishing_api,
        entity: document,
      ).call
    }
  end

  def publishing_api_draft_unpublisher
    ->(document) {
      publishing_api_v2.unpublish(document.id, type: "gone", allow_draft: true)
    }
  end

  def rummager_exporter
    ->(document, _ = nil) {
      RummagerIndexer.new.add(
        format_document_for_indexing(document)
      )
    }
  end

  def rummager_withdrawer
    ->(document) {
      RummagerIndexer.new.delete(
        format_document_for_indexing(document)
      )
    }
  end

  def format_document_for_indexing(document)
    raise NotImplementedError
  end

  def format_links_for_publishing_api(document)
    {
      organisations: organisation_content_ids
    }
  end

  def email_alert_api
    ManualsPublisherWiring.get(:email_alert_api)
  end

  def publication_alert_exporter
    ->(document) {
      if !document.minor_update
        EmailAlertExporter.new(
          email_alert_api: email_alert_api,
          formatter: publication_alert_formatter(document),
        ).call
      end
    }
  end

  def publication_alert_formatter
    raise NotImplementedError
  end

  def publication_logger
    ->(document) {
      unless document.minor_update?
        PublicationLog.create!(
          title: document.title,
          slug: document.slug,
          version_number: document.version_number,
          change_note: document.change_note,
        )
      end
    }
  end

  def url_maker
    UrlMaker.new
  end

  def publishing_api
    ManualsPublisherWiring.get(:publishing_api)
  end

  def publishing_api_v2
    ManualsPublisherWiring.get(:publishing_api_v2)
  end
end
