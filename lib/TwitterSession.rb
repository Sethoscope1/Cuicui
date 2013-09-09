require 'singleton'
require 'oauth'
require 'yaml'
require 'launchy'

class TwitterSession

  attr_reader :access_token

  include Singleton

  CONSUMER_KEY = 'U2wzHinqT6H6lnFKuRhvw'
  CONSUMER_SECRET = 'otDUJCVwhZoxF830R8946EO8vvHmYeJdAaoTUocca8s'

  CONSUMER = OAuth::Consumer.new(
    CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

  def initialize
    @access_token = get_access_token
  end


  def self.get(*args)
    self.instance.access_token.get(*args)

  end


  def self.post(*args)
    self.instance.access_token.get(*args)

  end



  protected
  def get_access_token
    if File.exist?(token_file)
      File.open(token_file) { |f| YAML.load(f) }
    else
      access_token = request_access_token
      File.open(token_file, 'w') { |f| YAML.dump(access_token, f) }
      access_token
    end
  end


  def request_access_token
    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url
    puts "Go to this URL: #{authorize_url}"
    Launchy.open(authorize_url)

    puts "Login - give us your code"
    oauth_verifier = gets.chomp

    access_token = request_token.get_access_token(
      :oauth_verifier => oauth_verifier
    )
  end



end