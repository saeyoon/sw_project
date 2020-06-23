class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show, :destroy]
  before_action :check_ownership, only: [:edit, :update, :destroy]
  def index
	  @posts = Post.paginate(page: params[:page], per_page: 10).order('created_at desc')
	  #@posts_count = current_user.posts.length 
  end

  def new
  end

  def create
	  new_post= Post.new(user_id: current_user.id, content: params[:content], image: params[:image], title: params[:title])
	  if new_post.save
		  redirect_to root_path
	  else
		  redirect_to new_post_path
	  end
  end
  
  def show
	  @post = Post.find_by(id: params[:id])
  end
  
  def mypage
	  @posts = current_user.posts
  end
  def edit
  end

  def update
	  @post.content = params[:content]
	  
	  if @post.save
		  redirect_to root_path
	  else
		  render :edit
	  end
  end
  
  def destroy
	  @post.destroy
	  redirect_to root_path
  end
	
  def check_ownership
	  @post = Post.find_by(id: params[:id])
	  redirect_to root_path if @post.user_id != current_user.id
  end
end
