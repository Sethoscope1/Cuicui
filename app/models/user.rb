require 'TwitterSession'
require 'json'

class User < ActiveRecord::Base
  attr_accessible :twitter_user_id, :screen_name

  has_many(
    :statuses,
    class_name: 'Status',
    foreign_key: :twitter_user_id,
    primary_key: :twitter_user_id
  )

  validates :twitter_user_id, presence: true, uniqueness: true

  def self.fetch_by_screen_name(screen_name)

    address_url = Addressable::URI.new(
      :scheme => "http",
      :host => "api.twitter.com",
      :path => "1.1/users/show.json",
      :query_values => {
        :screen_name => screen_name
      }
    ).to_s

    user_json = TwitterSession.new.access_token.get(address_url).body
    self.parse_twitter_params(user_json)

  end


  def self.parse_twitter_params(user_json)
    screen_name = JSON.parse(user_json)["screen_name"]
    id_string = JSON.parse(user_json)["id_str"]
    User.new(
      :twitter_user_id => id_string,
      :screen_name => screen_name
      )
  end

  def self.synch_statuses
    statuses = Status.fetch_statuses_for_user(@screen_name)
    statuses.each do |status|
      status_hash = Status.parse_tweet(status)
      unless Status.synched?(status_hash)
        Status.create!(status_hash)
      end
    end
    Status.find_by_twitter_user_id(@twitter_user_id)
  end
end
