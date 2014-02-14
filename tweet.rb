class Tweet
  attr_reader :username, :id, :location, :url, :neighbors, :parents, :children, :created_at

  def initialize(username, id, created_at, location=nil)
    @username = username
    @id = id
    @location = location
    @created_at = created_at
    @url = "https://twitter.com/#{username}/status/#{id}"
  end

  def get_neighbors
    puts "Getting neighbors for: #{username}"
    # current_children = []
    search_params = {
      count: 100
    }

    results = []

    search = TwitterLinkChain::CLIENT.search(id, search_params)
    results << search.reject {|t| t.user.screen_name == username}

    while next_params = search.send("next_page")
      search = TwitterLinkChain::CLIENT.search(id, search_params.merge(next_params))
      results << search.reject {|t| t.user.screen_name == username}
    end

    results.flatten.map do |tweet|
    # .reject {|t| t.user.screen_name == username}.map do |tweet|
      username = tweet.user.screen_name
      id = tweet.id
      created_at = tweet.created_at
      location = nil
      if !tweet.place.class == Twitter::NullObject
        location = tweet.place
      end

      # current_children << username

      # if current_children.select {|c| c == username}.size == 1
      Tweet.new(username, id, created_at, location)
      # else
      #   nil
      # end
    end
    # .compact
  end

end