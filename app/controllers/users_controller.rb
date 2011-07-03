class UsersController < ApplicationController
  
  before_filter :login_required, :only=>['welcome', 'change_password', 'hidden']
  def create
    
    @user = User.new
    if request.post?  
      
      @user = User.new(params[:user])
      if @user.save
        session[:user] = User.authenticate(@user.login, @user.password)
        flash[:message] = "Signup successful"
        redirect_to :action => "welcome"          
      else
        flash[:warning] = "Signup unsuccessful"
      end
    end
  end

  def login
    
    if request.post?
      if session[:user] = User.authenticate(params[:user][:login], params[:user][:password])
        flash[:message]  = "Login successful"
        redirect_to_stored
      else
        flash[:message] = "Login unsuccessful"
      end
    end
  end

  def logout
    
    session[:user] = nil
    flash[:message] = 'Logged out'
    redirect_to :action => 'login'
  end

  def delete
    
    
  end

  def edit
  end

  def forgot_password
    
    if request.post?
      u= User.find_by_email(params[:user][:email])
      if u and u.send_new_password
        flash[:message]  = "A new password has been sent by email."
        redirect_to :action=>'login'
      else
        flash[:warning]  = "Couldn't send password"
      end
    end
  end
  
  def welcome
    
  end
  
  def hidden
    
  end
end
