class PostsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @user = User.find(params[:user_id])
    @post = Post.where(author_id: @user.id).order(created_at: :desc)
  end

  def show
    @user = User.find(params[:user_id])
    @post = Post.includes(:author, :comments).find(params[:id])
  end

  def new
    @user = current_user
    @post = Post.new
  end

  def create
    @current_user = User.find(params[:user_id])
    @post = @current_user.posts.new(post_params)
    @post.comments_counter = 0
    @post.likes_counter = 0

    if @post.save
      redirect_to @current_user
    else
      render :new, alert: 'An error has occurred while creating the post'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @user = User.find(params[:user_id])
    @post.destroy!
    redirect_to user_posts_path(@user.id), notice: 'Post deleted successfully!'
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
