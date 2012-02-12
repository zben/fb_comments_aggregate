class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  def likes
    @likes ||= graph.get_connections(uid, 'likes')
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end
  
  def friends
    @friends ||= graph.get_connections(uid,'friends').map{|x| {:value=>x["id"], :name=> x["name"]}}

  end
  
  
  def friend_feed friend_uid, count=10 
    @friend_feed ||= @graph.get_connections(friend_uid,'posts',{:limit=>count})
  end
  
  def friend_commenter_summary friend_uid
    
    comments = friend_feed(friend_uid,100).
                map{|x| x["comments"]}.
                select{|x| x.has_key?("data")}.
                map{|x| x["data"].
                map{|x| x["from"]}}.
                sum
    if comments == 0
      []
    else
      comments = comments.group_by{|x| x}.map{|a,b| [a,b.length]}
    end
  end
end
