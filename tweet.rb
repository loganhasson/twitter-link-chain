class Tweet
  attr_reader :url, :username, :neighbors, :parents, :children, :linked_url, :id
  
  TWEET_IDS = []

  def initialize(url, username, linked_url, id)
    @url = url
    @username = username
    @linked_url = linked_url
    @id = id
    TWEET_IDS << id
    @neighbors = get_neighbors
    @parents = []
    @children = []
  end

  def get_neighbors
    puts "Getting neighbors for: #{username}"
    puts ""

    backward = TwitterLinkChain::CLIENT.search(linked_url).reject {|t| t.retweet? == true || t.user.screen_name == username}.map do |tweet|
      Tweet.new(tweet.url, tweet.user.screen_name, tweet.urls.first.expanded_url, tweet.id) if !TWEET_IDS.include?(tweet.id)
    end.compact

    forward = TwitterLinkChain::CLIENT.search(url).reject {|t| t.retweet? == true}.map do |tweet|
      Tweet.new(tweet.url, tweet.user.screen_name, tweet.urls.first.expanded_url, tweet.id) if !TWEET_IDS.include?(tweet.id)
    end.compact

    backward + forward
  end

end