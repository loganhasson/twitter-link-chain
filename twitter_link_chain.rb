class TwitterLinkChain
  attr_accessor :parent_chain
  attr_reader :traveled_path, :visited_tweets, :tweet_queue

  CLIENT = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_SECRET"]
  end

  def initialize(starting_tweet)
    @starting_tweet = starting_tweet
    @traveled_path = [starting_tweet]
    @visited_tweets = [starting_tweet]
    @tweet_queue = [starting_tweet]
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
      :url => tweet.url,
      :username => tweet.user.screen_name,
      :linked_url => tweet.urls.first.expanded_url,
      :id => tweet.id
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
      tweet.get_neighbors.each do |neighbor|
        if !visited?(neighbor)
          add_to_path(tweet, neighbor)
          add_to_arrays(neighbor)
        end
      end
    end
  end

end