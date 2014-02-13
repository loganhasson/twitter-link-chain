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

    TwitterLinkChain::CLIENT.search(id).reject {|t| t.retweet? == true}.map do |tweet|
      screen_name = tweet.user.screen_name
      id = tweet.id
      created_at = tweet.created_at
      location = nil
      if !tweet.place.class == Twitter::NullObject
        location = tweet.place
      end

      Tweet.new(screen_name, id, created_at, location)
    end
  end

end