require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 42
    @user = User.new(@graph, @uid)
    
  end

  describe 'retrieving friends' do
    before do
      @friends = [
        {
          "name" => "Ben Zhang",
          "id" => "6092929747",
        },
        {
          "name" => "James Bond",
          "id" => "7585969235",
        }
      ]
      @results = [
        {
          :name => "Ben Zhang",
          :value => "6092929747",
        },
        {
          :name => "James Bond",
          :value => "7585969235",
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'friends').once.and_return(@friends)
    end

    describe '#friends' do
      it 'should retrieve the friends via the graph api' do
        @user.friends.should == @results
      end

      it 'should memoize the result after the first call' do
        friends1 = @user.friends
        friends2 = @user.friends
        friends2.should equal(friends1)
      end
    end
  end
  
  describe 'retrieving feeds' do
    before do
      @feeds = [ 
        {"comments"=>{
            "data"=>[
              {"from"=>{"name"=>"Ben Zhang", "id"=>"4102710"}, "id"=>"82", "message"=>"commenti"}, 
              {"from"=>{"name"=>"Tim Garvey", "id"=>"700184770"}, "id"=>"410", "message"=>"what is that?"}
            ], 
         "count"=>2}, 
         "type"=>"status", 
         "message"=>"Ben is doing a code challenge"},  
       {"comments"=>{"count"=>0}, "type"=>"status","message"=>"Another example"},  
       {"comments"=>{
            "data"=>[
              {"from"=>{"name"=>"Ben Zhang", "id"=>"4102710"}, "id"=>"82", "message"=>"commenti"}, 
            ], 
         "count"=>1}, 
         "type"=>"status", 
         "message"=>"Ben is doing a code challenge"},
      ]
      @graph.should_receive(:get_connections).with("12345", "feed", {:limit=>"100"}).and_return(@feeds)
    end

    describe '#friend_commenter_summary friend_uid' do
      it 'should retrieve the likes via the graph api' do
        @user.friend_feed('12345',100).count.should == @feeds.count
      end

      it 'should memoize the result after the first call' do
        feeds1 = @user.friend_feed('12345',100)
        feeds2 = @user.friend_feed('12345',100)
        feeds2.should equal(feeds1)
      end
    end
  end
  
  describe 'get top commenters' do
    before do
      @friend_feed = [ 
        {"comments"=>{
            "data"=>[
              {"from"=>{"name"=>"Ben Zhang", "id"=>"4102710"}, "id"=>"82", "message"=>"commenti"}, 
              {"from"=>{"name"=>"Tim Garvey", "id"=>"700184770"}, "id"=>"410", "message"=>"what is that?"}
            ], 
         "count"=>2}, 
         "type"=>"status", 
         "message"=>"Ben is doing a code challenge"},  
       {"comments"=>{"count"=>0}, "type"=>"status","message"=>"Another example"},  
       {"comments"=>{
            "data"=>[
              {"from"=>{"name"=>"Ben Zhang", "id"=>"4102710"}, "id"=>"82", "message"=>"commenti"}, 
            ], 
         "count"=>1}, 
         "type"=>"status", 
         "message"=>"Ben is doing a code challenge"},
      ]
      @graph.should_receive(:get_connections).with('12345', 'feed',{:limit=>'100'}).and_return(@friend_feed)
    end

    describe '#top-commenters' do
      it 'should gets summary of commentors ' do
        @user.friend_feed('12345',100)
        @user.friend_commenter_summary("12345").should == [[{"name"=>"Ben Zhang", "id"=>"4102710"}, 2],  [{"name"=>"Tim Garvey", "id"=>"700184770"}, 1]]
      end

    end
  end
  

  
end
