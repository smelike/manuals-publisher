class ManualsController <  ApplicationController

  def index
    if current_user.gds_editor?
      @manuals = Manual.all
    else
      @manuals = Manual.where(organisation_content_id: current_user.organisation_content_id)
    end
  end

  def show
    @manual = Manual.find(content_id: params[:content_id])
  end

  def new
    @manual = Manual.new
  end

  def create
    @manual = Manual.new(params[:manual])

    if @manual.valid?
      if @manual.save!
        flash[:success] = "Created #{@manual.title}"
        redirect_to manuals_path
      else
        flash.now[:danger] = "There was an error creating #{@manual.title}. Please try again later."
        render :new
      end
    else
      flash.now[:danger] = manual_error_messages
      render :new, status: 422
    end
  end

private

  def manual_error_messages
    manual_errors = @manual.errors.messages
    errors = content_tag(:p,
      %Q{
        There #{manual_errors.length > 1 ? 'were' : 'was' } the following
        #{manual_errors.length > 1 ? 'errors' : 'error' } with your Manual:
      }
    )
    errors += content_tag :ul do
      @manual.errors.full_messages.map { |e| content_tag(:li, e) }.join('').html_safe
    end
  end


end
