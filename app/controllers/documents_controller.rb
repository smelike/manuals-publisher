require 'gds_api/publishing_api_v2'

class DocumentsController <  ApplicationController

  def index
    unless params[:document_type]
      redirect_to "/#{document_types.keys.first}"
      return
    end

    @documents = publishing_api.get_content_items(
      content_format: current_format.format_name,
      fields: [
        :base_path,
        :content_id,
        :title,
        :public_updated_at,
      ]
    ).to_ostruct
  end

  def new
    @document = current_format.klass.new
  end

  def create
    document = current_format.klass.new(
      filtered_params(params[:"#{current_format.format_name}"])
    )

    presented_document = DocumentPresenter.new(document)

    request = publishing_api.put_content(document.content_id, presented_document.to_json)

    if request.code == 200
      flash[:success] = "Created #{document.title}"
      redirect_to documents_path(document_type: current_format.document_type)
    else
      errors = request.body.error.fields.map { |k, v|
        "#{k}: #{v}"
      }
      flash[:error] = errors.join(', ')
      render :new, locals: { document: current_format.klass.new }
    end
  end

  def show
    @document = current_format.klass.from_publishing_api(publishing_api.get_content(params[:id]).to_ostruct)
  end

private

  def document_type
    params[:document_type]
  end

  def filtered_params(params_of_document)
    filter_blank_multi_selects(params_of_document).with_indifferent_access
  end

  # See http://stackoverflow.com/questions/8929230/why-is-the-first-element-always-blank-in-my-rails-multi-select
  def filter_blank_multi_selects(values)
    values.reduce({}) { |filtered_params, (key, value)|
      filtered_value = value.is_a?(Array) ? value.reject(&:blank?) : value
      filtered_params.merge(key => filtered_value)
    }
  end

  def publishing_api
    @publishing_api ||= SpecialistPublisher.services(:publishing_api)
  end

end
