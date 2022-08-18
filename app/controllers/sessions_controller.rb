class SessionsController < ApplicationController
  def new
    
  end
  
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        flash[:success] = "#{user.name} でログインしました"
        redirect_back_or user
      else
        message = "アクティベーションができておりません。"
        message += "アクティベーション用のメールを確認し、アクティベーションを行なってください"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "メールアドレス、またはパスワードが誤っています"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
