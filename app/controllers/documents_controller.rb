class DocumentsController < ApplicationController

  def index
  end

  def new
    render :new, locals: { document: document_for(document_type).new }
  end

  def create
    document = document_for(document_type).new(filtered_params(params[:cma_case]))

    if document.save!
      redirect_to documents_path
    else
      render :new, locals: { document: document_for(document_type).new }
    end
  end

private

  def document_type
    params[:document_type]
  end

  def document_for(document_type)
    case document_type
    when "cma-cases"
      CmaCase
    end
  end

  def filtered_params(params_of_document)
    # TODO: Make this work like the ManualsController parameter filtering
    # We shouldn't make our hashes indifferent. Let's make the keys consistently symbols
    filter_blank_multi_selects(params_of_document).with_indifferent_access
  end

  # See http://stackoverflow.com/questions/8929230/why-is-the-first-element-always-blank-in-my-rails-multi-select
  def filter_blank_multi_selects(values)
    values.reduce({}) { |filtered_params, (key, value)|
      filtered_value = value.is_a?(Array) ? value.reject(&:blank?) : value
      filtered_params.merge(key => filtered_value)
    }
  end
end
