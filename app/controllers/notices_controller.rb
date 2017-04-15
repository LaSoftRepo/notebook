class NoticesController < ApplicationController
  include Breadcrumbs::Notice
  before_action :authenticate_user

  def index
    @notices = current_section.notices
    render 'notices/index'
  end

  def show
    @notice = current_section.notices.find params[:id]
    render 'notices/show'
  end

  def new
    @notice = current_section.notices.build
    render 'notices/new'
  end

  def create
    @notice = current_section.notices.build notice_params
    if @notice.save
      flash[:success] = "#{@notice.name} successfully created."
      redirect_to notebook_section_notice_path(id: @notice.id)
    else
      flash.now[:error] = 'We can not create a notice. Please correct the fields.'
      render 'notices/new', status: 422
    end
  end

  private

  def notice_params
    params.require(:notice).permit(:name, :text)
  end
end
