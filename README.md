# Twitter Link Chain Mapper

## Step 1

Set up two applications on [Twitter](http://dev.twitter.com) and generate your
credentials.

## Step 2

Create `config/twitter_api_credentials.rb` and set the following variables:

```ruby
ENV["CONSUMER_KEY_1"] = ""
ENV["CONSUMER_SECRET_1"] = ""
ENV["ACCESS_TOKEN_1"] = ""
ENV["ACCESS_SECRET_1"] = ""

ENV["CONSUMER_KEY_2"] = ""
ENV["CONSUMER_SECRET_2"] = ""
ENV["ACCESS_TOKEN_2"] = ""
ENV["ACCESS_SECRET_2"] = ""
```

## Step 3

Run `bundle install` from your command line.

## Step 4

Run with `ruby bin/twitter_link_chain`.

Built by [@loganhasson](http://twitter.com/loganhasson) in NYC. Fork away! :-)