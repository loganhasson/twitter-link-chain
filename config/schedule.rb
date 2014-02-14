every 20.minutes do
  command "mv /Users/loganhasson/Development/code/flatiron/curriculum/twitter-link-chain/twitter_link_chain.dot /Users/loganhasson/Development/code/flatiron/curriculum/twitter-link-chain/backup_files/twitter_link_chain.dot.bak"
  command "mv /Users/loganhasson/Development/code/flatiron/curriculum/twitter-link-chain/twitter_link_chain.png /Users/loganhasson/Development/code/flatiron/curriculum/twitter-link-chain/backup_files/twitter_link_chain.png.bak"
  command "cd /Users/loganhasson/Development/code/flatiron/curriculum/twitter-link-chain && bundle && ruby bin/twitter_link_chain"
end