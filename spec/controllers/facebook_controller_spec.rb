require 'spec_helper'

describe FacebookController do

  describe 'index with GET' do
    before do
      @user = User.new(mock('graph'), '12345')
      @oauth = mock('oauth')
      @graph = mock('graph')
      Koala::Facebook::OAuth.should_receive(:new).and_return(@oauth)

    end

    context 'when logged into facebook' do
      before do
        user_info = {'access_token' => '1234567890', 'uid' => '12345'}
        @oauth.should_receive(:get_user_info_from_cookie).and_return(user_info)
        Koala::Facebook::GraphAPI.should_receive(:new).with('1234567890').and_return(@graph)
        User.should_receive(:new).and_return(@user)
        @user.should_receive(:friend_feed).with("12345").and_return((1..100).to_a)
        @user.should_receive(:friend_commenter_summary).with("12345").and_return((1..100).to_a)
        @user.should_receive(:friends).and_return((1..100).to_a)
        @user.should_receive(:profile_picture_url).with("12345")
        @user.should_receive(:user_info).with("12345")
        get :index,{:uid=>"12345"}
        
      end
    
      it do
        response.should be_success
      end

#      it 'should assign likes' do
#        assigns[:likes_by_category].should == @likes
#      end
    end

    context 'when not logged into facebook' do
      before do
        @oauth.should_receive(:get_user_info_from_cookie).and_return(nil)

        get :index
      end

      it 'should redirect to the login page' do
        response.should redirect_to(:action => :login)
      end
    end
  end

  describe 'login with GET' do
    before do
      get :login
    end

    it do
      response.should be_success
    end
  end
end
