class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :reset_password, :reset_password_submit]
  before_filter :load_user, :only => [:edit, :update, :show]
  allow :exec => :authorize_user, :only => [:edit, :update]

  def new
    @tab = TabConstants::REGISTER
    if params[:group_code]
      @group = Group.find_by_code(params[:group_code])
      handle_invalid_code
      if current_user
        @user = current_user
        create_group_user_and_redirect
      end
    end
    @user = User.new
  end

  def create
    handle_group_invite and return if params[:group_code]

    @user = User.new(params[:user])
    if verify_recaptcha && @user.save
      redirect_to user_url(@user)
    else
      flash.now[:error] = "Please re-enter the words from the image again!"
      @tab = TabConstants::REGISTER
      render :action => "new"
    end
  end

  def edit

  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successful updated your profile"
      redirect_to user_path(@user)
    else
      render :action => "edit"
    end
  end

  def show
    @tab = TabConstants::HOME
  end

  def index

  end

  def reset_password
    @user = User.find_using_perishable_token(params[:reset_password_code], 1.week) || (raise Exception)
  end

  def reset_password_submit
    @user = User.find_using_perishable_token(params[:reset_password_code], 1.week) || (raise Exception)
    if @user.update_attributes(params[:user])
      flash.now[:notice] = "Successfully reset password."
      redirect_to @user
    else
      flash.now[:notice] = "There was a problem resetting your password."
      render :action => :reset_password
    end
  end

  private

  def handle_group_invite
    @group = Group.find_by_code(params[:group_code])
    handle_invalid_code

    @user = User.new(params[:user])
    if verify_recaptcha && @user.save
      create_group_user_and_redirect
    else
      flash.now[:error] = "Please re-enter the words from the image again!"
      render :action => "new"
    end
  end

  def handle_invalid_code
    unless @group
      flash[:error] = "Invalid code. Try joining the group with proper url"
      redirect_to root_url and return
    end
  end

  def create_group_user_and_redirect
    @group.users << @user if @group
    redirect_to user_url(@user)
  end

  def load_user
    @user = User.find(params[:id])
  end

  def authorize_user
    (@user == current_user) || (current_user.app_admin?)
  end
end