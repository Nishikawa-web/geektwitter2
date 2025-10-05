class TweetsController < ApplicationController

  before_action :authenticate_user! 

  def index
  all_tweets = Tweet.order(created_at: :desc)

  # ① 地図用の変数（全てのデータ）
  @tweets_for_map = all_tweets

  # ② 一覧表示用の変数（ページ分割したデータ）
  @tweets_for_list = all_tweets.page(params[:page]).per(10)
        if params[:tag]
          Tag.create(name: params[:tag])
        end
    if params[:search].present?
      # あいまい検索で該当する投稿を1件探す
      searched_tweet = Tweet.find_by('body LIKE ?', "%#{params[:search]}%")

      # 該当する投稿があり、緯度・経度も存在する場合
      if searched_tweet&.lat.present? && searched_tweet&.lng.present?
        # ビューで使えるようにインスタンス変数に緯度と経度を格納
        @searched_lat = searched_tweet.lat
        @searched_lng = searched_tweet.lng
      end
    end
  end
  def new
    @tweet = Tweet.new
  end

  def create
    tweet = Tweet.new(tweet_params)

    tweet.user_id = current_user.id

    if tweet.save
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end
    def show
    @tweet = Tweet.find(params[:id])
    end

    def edit
      @tweet = Tweet.find(params[:id])
    end

    def update
      tweet = Tweet.find(params[:id])
      if tweet.update(tweet_params)
        redirect_to :action => "show", :id => tweet.id
      else
        redirect_to :action => "new"
      end
    end

    def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to action: :index
    end

  private

  def tweet_params
    params.require(:tweet).permit(:name, :body, :image, :lat, :lng, tag_ids: [])
  end
end 