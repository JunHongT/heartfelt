class PostsController < ApplicationController

  # before_action :check_if_author, only: [:edit, :update, :destroy]

  def index
    @post = Post.new
    @posts = Post.friends_posts(current_user).page(params[:page]).per(5)
    @comment = Comment.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:post_success] = 'Post successful!'
      redirect_to root_url

       # Initialising spell checker
       spell = Gingerice::Parser.new
       spell.parse @post.content
 
       # Corrected spelling is within spell.result
       puts spell.result
 
       # Create an instance for usage
       analyzer = Sentimental.new
 
       # Load the default sentiment dictionaries
       analyzer.load_defaults
 
       # Set a global threshold
       analyzer.threshold = 0.2
       puts "\nSentiment Analysis Results"
       puts analyzer.sentiment spell.result
       sentiment_score = analyzer.score spell.result
       puts sentiment_score
       
       # actual colour processing is here
       if sentiment_score > 0.2
          @post.emotion = "Pink"
          @post.save
          
       elsif sentiment_score < -0.2
          @post.emotion = "Purple"
          @post.save
         
       end
    else
      flash[:post_failure] = 'Post did not save - text content required.'
      redirect_to root_url
    end
  end

  def edit
    post
  end

  def update
    if post.update_attributes(post_params)
      flash[:success] = "Post updated!"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def show
    post
    @comment = Comment.new
  end

  def destroy
    post.destroy
    flash[:success] = "Post successfully deleted."
    redirect_to root_url
  end

  private

  def post
    @post ||= Post.find(params[:id])
  end

  def check_if_author
    @user = post.user
    redirect_to(root_url) unless @user == current_user
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end
end
