class Tweet
  attr_reader :username, :id, :location, :url, :neighbors, :parents, :children, :created_at
  
  TWEET_IDS = []

  def initialize(username, id, created_at, location=nil)
    @username = username
    @id = id
    @location = location
    @created_at = created_at
    @url = "https://twitter.com/#{username}/status/#{id}"
    TWEET_IDS << id
  end

  def get_neighbors(twitter_link_chain)
    puts "Getting neighbors for: #{username}"

    TwitterLinkChain::TLC_STORE.transaction do
      TwitterLinkChain::TLC_STORE["traveled_path"] = twitter_link_chain.traveled_path
      TwitterLinkChain::TLC_STORE["visited_tweets"] = twitter_link_chain.visited_tweets
      TwitterLinkChain::TLC_STORE["tweet_queue"] = twitter_link_chain.tweet_queue
    end

    TwitterLinkChain::CLIENT.search(id).reject {|t| t.retweet? == true}.map do |tweet|
      username = tweet.user.screen_name
      id = tweet.id
      created_at = tweet.created_at
      location = nil
      if !tweet.place.class == Twitter::NullObject
        location = tweet.place
      end

      Tweet.new(username, id, created_at, location)
    end
  end

end