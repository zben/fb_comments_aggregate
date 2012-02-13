class FacebookController < ApplicationController

  before_filter :facebook_auth
  before_filter :require_login, :except => :login

  helper_method :logged_in?, :current_user
  


    
  def index
    uid = (params[:as_values_uid] ? params[:as_values_uid].split(',')[0] : params[:uid]) || current_user.uid

    @posts = current_user.friend_feed(uid)[0..25]
    @top_commenters = current_user.friend_commenter_summary(uid)[0..5]
    @friends = current_user.friends
    @profile_picture_url = current_user.profile_picture_url uid
    @user_info = current_user.user_info uid 
    
  end

  def login
    @text = RDiscount.new(File.read('readme.md')).to_html
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
        @user = User.new(@graph, fb_user_info['user_id'])
      end
    end
end
