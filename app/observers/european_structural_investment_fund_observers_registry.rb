require "formatters/european_structural_investment_fund_indexable_formatter"
require "formatters/european_structural_investment_fund_publication_alert_formatter"
require "markdown_attachment_processor"

class EuropeanStructuralInvestmentFundObserversRegistry < AbstractSpecialistDocumentObserversRegistry

private
  def format_document_for_indexing(document)
    EuropeanStructuralInvestmentFundIndexableFormatter.new(
      MarkdownAttachmentProcessor.new(document)
    )
  end

  def publication_alert_formatter(document)
    EuropeanStructuralInvestmentFundPublicationAlertFormatter.new(
      url_maker: url_maker,
      document: document,
    )
  end
end
