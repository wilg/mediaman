require 'httparty'

module Mediaman
  
  module Trakt
        
    attr_accessor :api_key
    def self.api_key=(key)
      @@api_key = key
    end
    
    def self.api_key
      defined?(@@api_key) ? @@api_key : ENV['TRAKT_API_KEY']
    end
    
    class Fetcher < Hash      
      include HTTParty
      format :json
      
      def self.from_hash(hash = {})
        f = self.new()
        f.merge!(hash) if hash.present?
        f
      end
      
      def initialize(options = {})
        self.options = options
        self.merge!(fetch! || {}) if self.respond_to?(:fetch!)
      end
      attr_accessor :options
      attr_accessor :response
      
    end
    
    class Movie < Fetcher
      
      def slug
        options[:slug].presence || "#{options[:title].parameterize}-#{options[:year].to_s.parameterize}"
      end
      
      def fetch!
        Movie.get("http://api.trakt.tv/movie/summary.json/#{Trakt.api_key}/#{slug}")
      end
      
    end
   
    class TVEpisode < Fetcher
      
      attr_accessor :show
      
      def fetch!
        url = "http://api.trakt.tv/show/episode/summary.json/#{Trakt.api_key}/#{slug}"
        self.response = r = self.class.get(url)
        self.show = Trakt::TVShow.from_hash self.response['show']
        self.response['episode']
      end

      def slug
        options[:slug].presence || "#{title_slug}/#{options[:season_number]}/#{options[:episode_number]}"
      end
      
      def title_slug
        options[:title_slug].presence || "#{options[:show_title].parameterize}"
      end

    end
    
    class TVShow < Fetcher
      
    end

  end
  
end