class GroupUsersController < ApplicationController
  before_filter :load_group_and_user
  allow :exec => :authorize_user

  def update
    if params[:suspend]
      if @group_user.suspend!
        flash[:notice] = "User has been suspended :("
      else
        flash[:error] = "User cannot be suspended from the group because of having non zero credit :P"
      end
    elsif params[:activate]
      @group_user.activate!
      flash[:notice] = "User has been reactivated :)"
    end

    redirect_to groups_path
  end

  private

  def load_group_and_user
    @group = current_user.groups.find(params[:group_id])
    @group_user = @group.group_users.find(params[:id])
  end

  def authorize_user
    current_user == @group.admin
  end

end