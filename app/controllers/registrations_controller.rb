class RegistrationsController < ApplicationController

  def new
    @session = session
    flash[:message] = "Enter your temporary password to login"
  end

  def create
    session[:return_to] ||= request.referer
    user = User.find_by(email_address: params[:email_address])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome, #{user.name}!"
      redirect_to edit_user_path(user)
    else
      flash[:errors] = "Invalid Login"
      redirect_to :back
    end
  end

end
