class ItemsController < ApplicationController
  def index
    @items = current_user.items.paginate(:page => params[:page], :per_page => params[:per_page] || 50)
  end
end