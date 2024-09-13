
class PostsController < ApplicationController
  require 'csv'

  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [ :index ]
  before_action :correct_user, only: [ :edit, :update, :destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.order('created_at DESC')
  end

  def export_csv
    @posts = Post.all

    respond_to do |format|
      format.csv do
        send_data generate_csv(@posts), filename: "posts-#{Date.today}.csv"
      end
    end
  end

  def import_csv
    # Display the CSV upload form
  end

  #csv fiel import with background process
  def post_import_process
    file = params[:file]

    if file.present?
      PostImportJob.perform_now(file)
      redirect_to posts_path, notice: 'CSV imported successfully.'
    else
      redirect_to import_csv_posts_path, notice: 'Please select a file to import.'
    end
  end

  # csv file import with action
  def import_csv_process
    file = params[:file]

    if file.present?
      # import with simple way
      CSV.foreach(file.path, headers: true) do |row|

        id = row['id'].to_i
        action = row['action'].to_s.downcase
        case action

        when 'create'
          post_info = { title: row['title'],
          conntent: row['conntent'], user_id: row['user_id'], created_at: row['created_at'] }
          Post.create!(post_info)
        when 'update'
          post_info = { title: row['title'],
          conntent: row['conntent'], created_at: row['created_at'] }
          post = Post.find_by(id: id)

          post.update(post_info) if post
        when 'delete'
          post = Post.find_by(id: id)
          if post
            post.comments.destroy_all
            post.destroy
          end
        else
          puts 'invalid action'
        end
      end

      redirect_to posts_path, notice: 'CSV imported successfully.'
    else
      redirect_to import_csv_posts_path, notice: 'Please select a file to import.'
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
    # @comment = Comment.new
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])

    redirect_to posts_path, notice: "Not authorize to this post" if @post.nil?
  end

  def myposts
    user = User.find(current_user.id)
    # @posts = current_user.posts
    @posts = Post.find_by(user_id: user.id)
  end
  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)
    # @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :conntent, :user_id)
    end

    def generate_csv(posts)
      CSV.generate(headers: true) do |csv|
        csv << ['id','title', 'conntent', 'user_id', 'created_at']

        posts.each do |post|
          csv << [post.id,post.title, post.conntent, post.user_id , post.created_at]
        end
      end
    end
end
