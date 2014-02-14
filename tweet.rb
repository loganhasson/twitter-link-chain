class Tweet
  attr_reader :username, :id, :location, :url, :neighbors, :parents, :children, :created_at, :retweet, :retweet_count

  @@count = 0

  def initialize(username, id, created_at, retweet, retweet_count, location=nil)
    @username = username
    @id = id
    @created_at = created_at
    @retweet = retweet
    @retweet_count = retweet_count
    @location = location
    @url = "https://twitter.com/#{username}/status/#{id}"
  end

  def self.count=(count)
    @@count += count
  end

  def self.count
    @@count
  end

  def clients
    [TwitterLinkChain::CLIENT_ONE, TwitterLinkChain::CLIENT_TWO]
  end

  def client_to_use
    Tweet.count <= 175 ? clients[0] : clients[1]
  end

  def increase_search_count
    Tweet.count += 1
  end

  def get_neighbors
    puts "Getting neighbors for: #{username}"
    # current_children = []
    search_params = {
      count: 100
    }

    results = []

    increase_search_count
    search = client_to_use.search(id, search_params)
    results << search.reject {|t| t.user.screen_name == username}

    while next_params = search.send("next_page")
      increase_search_count
      search = client_to_use.search(id, search_params.merge(next_params))
      results << search.reject {|t| t.user.screen_name == username}
    end

    results.flatten.map do |tweet|
    # .reject {|t| t.user.screen_name == username}.map do |tweet|
      username = tweet.user.screen_name
      id = tweet.id
      created_at = tweet.created_at
      location = nil
      retweet = tweet.retweet?
      retweet_count = tweet.retweet_count
      if !tweet.place.class == Twitter::NullObject
        location = tweet.place
      end

      # current_children << username

      # if current_children.select {|c| c == username}.size == 1
      Tweet.new(username, id, created_at, retweet, retweet_count, location)
      # else
      #   nil
      # end
    end
    # .compact
  end

end