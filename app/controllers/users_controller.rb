class UsersController < ApplicationController
  def index
    @current_user = ApplicationController.new.current_user
    @users = User.all.order(updated_at: :desc)
  end

  def show
    @current_user = ApplicationController.new.current_user
    @user = User.find(params[:id])
    @posts = @user.last_three_posts
  end
end
