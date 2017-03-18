class NoticesController < ApplicationController
  before_action :authenticate_user

  def index
    notices = current_section.notices
    render 'notices/index', locals: { notices: notices }
  end

  def show
    notice = current_section.notices.find params[:id]
    render 'notices/show', locals: { notice: notice }
  end

  def new
    notice = current_section.notices.build
    render 'notices/new', locals: { notice: notice }
  end

  def create
    notice = current_section.notices.build notice_params
    if notice.save
      flash[:success] = "#{notice.name} successfully created."
      redirect_to notebook_section_notice_path(id: notice.id)
    else
      flash.now[:error] = 'We can not create a notice. Please correct the fields.'
      render 'notices/new', locals: { notice: notice }, status: 422
    end
  end

  private

  def notice_params
    params.require(:notice).permit(:name, :text)
  end
end
