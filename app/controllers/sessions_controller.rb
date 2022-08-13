class SessionsController < ApplicationController
  def new
    
  end
  
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = "#{user.name} でログインしました"
      redirect_to user
    else
      flash.now[:danger] = "メールアドレス、またはパスワードが誤っています"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
