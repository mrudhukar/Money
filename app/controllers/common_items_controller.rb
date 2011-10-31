class CommonItemsController < ApplicationController
  before_filter :find_group_and_group_user
  allow :exec => :check_auth

  def new
    @type = params[:type] || CommonItem::Type::SHARED_EQUALLY.to_s
    unless params[:type_change]
      @common_item = @group_user.common_items.new(:transaction_date => Date.today.strftime("%B %d,%Y"), :transaction_type => @type)
    end
  end

  def create
    @common_item = @group_user.common_items.new(params[:common_item])
    @users = @group.users

    if @common_item.transaction_type != CommonItem::Type::SHARED_EQUALLY
      @group.users.find_all_by_id(params[:item_cost].keys).each do |user|
        key = user.id.to_s
        unless params[:item_cost][key].blank? || params[:item_cost][key] == "0"
          item = @common_item.items.build(:user => user, :default_amount => params[:item_cost][key])
          item.common_item = @common_item
        end
      end
    else
      users = @group.users.find_all_by_id(params[:user_ids])
      default_amount = (@common_item.cost.to_f/users.size.to_f).round
      users.each do |user|
        item = @common_item.items.build(:user => user, :default_amount => default_amount)
        item.common_item = @common_item
      end
    end

    if @common_item.save
      flash[:notice]= "Item has been successfully added"
    else
      flash[:error]= "Sorry could not save this"
    end
    redirect_to :action => :index
  end

  def index
    @is_full_view = params[:full_view]
    if @group.admin == current_user && @is_full_view
      @common_items = @group.common_items.paginate(:page => params[:page]||1, :per_page => params[:per_page]||50, :order => "transaction_date desc, id DESC")
    else
      @common_items = CommonItem.paginate_by_sql(
        ["SELECT DISTINCT common_items.* FROM common_items,group_users,items WHERE items.common_item_id = common_items.id AND items.user_id = ? AND group_users.id = common_items.group_user_id AND group_users.group_id = ?
            UNION
          SELECT DISTINCT common_items.* FROM common_items WHERE common_items.group_user_id = ? ORDER BY transaction_date DESC, id DESC",
          @group_user.user_id, @group.id, @group_user.id], {:page => params[:page]||1, :per_page => params[:per_page]||50})
    end

    @total_cost = @common_items ? @group.common_items.collect(&:cost).sum : 0
    @active_group_users = @group.group_users.active
    @suspended_group_users = @group.group_users.suspended
  end

  def destroy
    @common_item = @group_user.common_items.find(params[:id])
    if @common_item.destroy
      flash[:notice] = "Successfully deleted"
    end
    redirect_to group_common_items_path(@group)
  end

  private

  def find_group_and_group_user
    @group = current_user.active_groups.find(params[:group_id])
    @group_user = @group.get_group_user(current_user)
  end

  def check_auth
    @group.users.include?(current_user)
  end

end
