class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      ImageConverterService.new(@post.id, Cloudinary::Utils.cloudinary_url(@post.photo.key)).generate_image
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :photo)
  end
end
