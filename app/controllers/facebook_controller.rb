class FacebookController < ApplicationController

  before_filter :facebook_auth
  before_filter :require_login, :except => :login

  helper_method :logged_in?, :current_user
  
  def index
    uid = params[:uid] || current_user.uid
    #@likes_by_category = current_user.likes_by_category
    @posts = current_user.friend_feed uid
    @top_commenters = current_user.friend_commenter_summary uid
    @friends = current_user.friends
  end

  def login
  end

  protected

    def logged_in?
      !!@user
    end

    def current_user
      @user
    end

    def require_login
      unless logged_in?
        redirect_to :action => :login
      end
    end

    def facebook_auth
      #FACEBOOK_APP_ID = '213342972085914'
      #FACEBOOK_SECRET_KEY = '5b59c74ffafd50c5b3191e0d7b3968ef'
      @oauth = Koala::Facebook::OAuth.new(FACEBOOK_APP_ID, FACEBOOK_SECRET_KEY)
      
      if fb_user_info = @oauth.get_user_info_from_cookie(request.cookies)
        @graph = Koala::Facebook::GraphAPI.new(fb_user_info['access_token'])
        logger.info fb_user_info['access_token']
        @user = User.new(@graph, fb_user_info['user_id'])
        logger.info fb_user_info['user_id']
      end
    end
end
