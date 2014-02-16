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
    @@count = count
  end

  def self.count
    @@count
  end

  def clients
    [
      TwitterLinkChain::CLIENT_ONE,
      TwitterLinkChain::CLIENT_TWO,
      TwitterLinkChain::CLIENT_THREE
    ]
  end

  def client_to_use
    clients[Tweet.count]
  end

  def increase_search_count
    if Tweet.count == 0
      Tweet.count = 1
    elsif Tweet.count == 1
      Tweet.count = 2
    elsif Tweet.count == 2
      Tweet.count = 0
    end
  end

  def get_neighbors
    puts "Getting neighbors for: #{username}"
    search_params = {count: 100}
    results = []
    next_search = nil

    increase_search_count
    search = client_to_use.search(id, search_params)
    sleep(2)

    results << search.reject {|t| t.user.screen_name == username}
    if search.entries.size > 0
      max_id = search.entries.last.id - 1
      next_search = client_to_use.search(id, search_params.merge(max_id: max_id))
    end

    if next_search
      while next_search.entries.size > 0
        results << next_search.reject {|t| t.user.screen_name == username}
        increase_search_count
        sleep(2)
        puts "Getting next page for: #{username}"
        if next_search.entries.size > 0
          max_id = next_search.entries.last.id - 1
          next_search = client_to_use.search(id, search_params.merge(max_id: max_id))
        end
      end
    end

    results.flatten.map do |tweet|
      username = tweet.user.screen_name
      id = tweet.id
      created_at = tweet.created_at
      location = nil
      retweet = tweet.retweet?
      retweet_count = tweet.retweet_count
      if !tweet.place.class == Twitter::NullObject
        location = tweet.place
      end

      Tweet.new(username, id, created_at, retweet, retweet_count, location)
    end
  end

end