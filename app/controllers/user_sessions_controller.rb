class UserSessionsController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :forgot_password, :forgot_password_lookup_email]

  def new
    @tab = TabConstants::LOGIN
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to session[:orginal_uri] || root_url
    else
      flash[:error] = "Login failed. Please try again"
      redirect_to login_path
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to root_url
  end

  def forgot_password
    if current_user
      redirect_to edit_user_url
    else
      @user_session = UserSession.new()
    end
  end

  def forgot_password_lookup_email
    if current_user
      redirect_to edit_user_url
    else
      user = User.find_by_email(params[:user_session][:email])
      if user
        user.send_forgot_password!
        flash.now[:notice] = "A link to reset your password has been mailed to you."
      else
        flash[:notice] = "Email #{params[:user_session][:email]} wasn't found.  Perhaps you used a different one?  Or never registered or something?"
        render :action => :forgot_password
      end
    end
  end


end
