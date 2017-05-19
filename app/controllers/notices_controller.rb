class NoticesController < ApplicationController
  include Breadcrumbs::Notice
  before_action :authenticate_user
  before_action :verify_section
  before_action :find_notice, only: [:show, :edit]

  def index
    @notices = current_section.notices
    @child_sections = current_section.child_sections
    render 'notices/index'
  end

  def show
    render 'notices/show'
  end

  def new
    @notice = current_section.notices.build
    render 'notices/new'
  end

  def create
    @notice = current_section.notices.build notice_params
    if @notice.save
      flash[:success] = t('created', name: @notice.name)
      redirect_to notebook_section_notice_path(id: @notice.id)
    else
      flash.now[:error] = t('notice.not_created')
      render 'notices/new', status: 422
    end
  end

  def edit
    render 'notices/edit'
  end

  private

  def find_notice
    @notice ||= current_section.notices.find params[:id]
  end

  def notice_params
    params.require(:notice).permit(:name, :text)
  end
end
