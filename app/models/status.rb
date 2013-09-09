require 'TwitterSession'
require 'json'

class Status < ActiveRecord::Base
  attr_accessible :twitter_status_id, :twitter_user_id, :body


  belongs_to(
    :user,
    class_name: 'User',
    foreign_key: :twitter_user_id,
    primary_key: :id
  )

  validates :twitter_status_id, presence: true, uniqueness: true

  def self.parse_twitter_status(status_json)
    body = JSON.parse(status_json)["body"]
    id_string = JSON.parse(status_json)["id_str"]
    user_id = JSON.parse(status_json)["user_id"]

    Status.new(
      :twitter_status_id => id_string,
      :twitter_user_id => user_id,
      :body => body
      )

  end

  def self.fetch_statuses_for_user(user)
    # https://api.twitter.com/1.1/statuses/user_timeline.json
    p address_url = Addressable::URI.new(
      :scheme => "https",
      :host => "api.twitter.com",
      :path => "1.1/statuses/user_timeline.json",
      :query_values => {
        :screen_name => user
      }
    ).to_s

    statuses_json = TwitterSession.new.access_token.get(address_url).body
    tweets = JSON.parse(statuses_json)
    # status_data = JSON.parse(statuses_json).first
  end

  def self.parse_tweet(tweet_json)
    body = tweet_json['text']
    twitter_status_id = tweet_json['id_str']
    twitter_user_id = tweet_json['user']['id_str']
    {
      :body => body,
      :twitter_status_id => twitter_status_id,
      :twitter_user_id => twitter_user_id
    }
  end

  def self.synched?(tweet_hash)
    if Status.find_by_twitter_status_id(tweet_hash[twitter_status_id]) == nil
      return false
    else
      return true
    end
  end



end
