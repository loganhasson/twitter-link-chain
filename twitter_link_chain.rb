class TwitterLinkChain
  attr_accessor :parent_chain
  attr_reader :traveled_path, :visited_tweets, :tweet_queue

  CLIENT = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_SECRET"]
  end

  TLC_STORE = YAML::Store.new "twitter_link_chain.store"

  def initialize(starting_tweet)
    stored = nil
    TLC_STORE.transaction do
      stored = TLC_STORE["stored"]
    end

    if stored == nil
      @starting_tweet = starting_tweet
      @traveled_path = [[nil,starting_tweet]]
      @visited_tweets = [starting_tweet]
      @tweet_queue = [starting_tweet]
    else
      TLC_STORE.transaction do
        @starting_tweet = TLC_STORE["current_tweet"]
        @traveled_path = TLC_STORE["traveled_path"]
        @visited_tweets = TLC_STORE["visited_tweets"]
        @tweet_queue = TLC_STORE["tweet_queue"]
      end
    end
  end

  def self.get_first_tweet_hash(starting_status_url)
    id = starting_status_url[/(\d)+$/].to_i
    link = true
    while link
      begin
        tweet = CLIENT.status(id)
        puts "#{tweet.user.screen_name}: #{id}"
        if tweet.urls
          id = tweet.urls.first.expanded_url.to_s[/(\d)+$/].to_i
        else
          link = false
        end
      rescue
        link = false
      end
    end

    {
      :username => tweet.user.screen_name,
      :id => tweet.id,
      :location => nil
    }

  end

  def visited?(tweet)
    visited_tweets.include?(tweet)
  end

  def add_to_path(parent, child)
    self.traveled_path << [parent, child]
    child.parents << parent
    parent.children << child
  end

  def add_to_arrays(tweet)
    self.visited_tweets << tweet
    self.tweet_queue << tweet
  end

  def map_graph
    while !tweet_queue.empty?
      tweet = tweet_queue.shift
      TLC_STORE.transaction do
        TLC_STORE["stored"] = true
        TLC_STORE["current_tweet"] = tweet
      end

      tweet.get_neighbors(self).each do |neighbor|
        if !visited?(neighbor)
          add_to_path(tweet, neighbor)
          add_to_arrays(neighbor)
        end
      end
    end
  end

  def display_graph(traveled_path)
    digraph do
      traveled_path.each do |pair|
        start = pair[0] == nil
        if start
          node("Start").label "Start"
        else
          node(pair[0].id).label pair[0].username if !node(pair[0].id)
          node(pair[1].id).label pair[1].username if !node(pair[1].id)
        end

        if start
          edge "Start", pair[1].id
        else
          edge pair[0].id, pair[1].id
        end
      end

      save "test", "png"
    end
  end

end