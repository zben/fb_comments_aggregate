class User
  attr_accessor :uid, :graph, :friend_feed
  
  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  
  def friends
    @friends ||= graph.get_connections(uid,'friends').map{|x| {:value=>x["id"], :name=> x["name"]}}

  end
  
  def profile_picture_url uid
    @graph.get_picture(uid,{:type=>"large"}) 
  end
  
  def user_info uid
    @graph.get_object(uid)
  end
  
  def friend_feed friend_uid, count=100 
    @friend_feed = @graph.get_connections(friend_uid,'feed',{:limit=>count.to_s})
  end
  
  def friend_commenter_summary friend_uid
    
    comments = @friend_feed.
                map{|x| x["comments"]}.
                select{|x| x.has_key?("data")}.
                map{|x| x["data"].
                map{|x| x["from"]}}.
                sum
    if comments == 0
      []
    else
      comments = comments.group_by{|x| x}.map{|a,b| [a,b.length]}.sort{|a,b| b[1]<=>a[1]}
    end
  end
end
