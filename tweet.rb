class Tweet
  attr_reader :url, :username, :neighbors, :parents, :children, :linked_url, :id, :starting
  
  TWEET_IDS = []
  STARTING_ID = []

  def initialize(url, username, linked_url, id, starting=false)
    @url = url
    @username = username
    @linked_url = linked_url
    @starting = starting
    @id = id

    if starting
      STARTING_ID << id
    end
    TWEET_IDS << id

    @parents = []
    @children = []

    # @neighbors = get_neighbors
  end

  def get_neighbors
    puts "Getting neighbors for: #{username}"
    puts ""

    if !starting || !STARTING_ID.include?(linked_url.to_s[/(\d)+$/].to_i)
      puts "about to search for: #{linked_url}"
      sleep(2)
      sideways = TwitterLinkChain::CLIENT.search(linked_url).reject {|t| t.retweet? == true || t.user.screen_name == username}.map do |tweet|
        Tweet.new(tweet.url, tweet.user.screen_name, tweet.urls.first.expanded_url, tweet.id) if !TWEET_IDS.include?(tweet.id) && !STARTING_ID.include?(tweet.id)
      end.compact
    end

    # forward = TwitterLinkChain::CLIENT.search(url).reject {|t| t.retweet? == true}.map do |tweet|
    #   Tweet.new(tweet.url, tweet.user.screen_name, tweet.urls.first.expanded_url, tweet.id) if !TWEET_IDS.include?(tweet.id)
    # end.compact
    sleep(2)
    forward = TwitterLinkChain::CLIENT.search(url).reject {|t| t.retweet? == true}.map do |tweet|
      Tweet.new(tweet.url, tweet.user.screen_name, tweet.urls.first.expanded_url, tweet.id) if !TWEET_IDS.include?(tweet.id)
    end.compact

    # TODO: Figure out how to now start the chain one level back (aka from the linked_url tweet)

    sideways + forward
  end

end