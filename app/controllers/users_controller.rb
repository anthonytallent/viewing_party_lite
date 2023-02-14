class UsersController < ApplicationController
  before_action :validate_user, only: :show
  def new

  end

  def create
    # validate_user is in the application_controller
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}"
      redirect_to dashboard_path
    else
      flash[:error] = user.errors.full_messages.to_sentence
      render :new
    end
  end

  def login_user
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to dashboard_path
    else
      flash[:error] = "Invalid email or password"
      render :login_form
    end
  end

  def show
    # @user = User.find_by(email: params[:email])
  end

  def log_out
    session.delete(:user_id)
    @user = nil
    redirect_to root_path
  end

  private

  def user_params
    params[:email].downcase!
    params.permit(:name, :email, :password, :password_confirmation)
  end
end