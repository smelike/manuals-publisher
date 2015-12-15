require 'govuk-content-schema-test-helpers'

 GovukContentSchemaTestHelpers.configure do |config|
   config.schema_type = 'publisher' # or 'publisher'
   config.project_root = Rails.root
 end
