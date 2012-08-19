require 'hashie'

module Mediaman
  
  class Metadata < Hashie::Mash
    
    def canonical_show_name
      show_details.title.presence || name.presence || raw_name.presence
    end
    
    def canonical_episode_name
      episode_details.title.presence
    end
    
    def canonical_movie_title
      movie_details.title.presence || name.presence || raw_name.presence
    end
    
    def episode_id
      "#{season_number}x#{"%02d" % episode_number}"
    end
    
    def library_category
      return "TV Shows" if tv?
      return "Movies" if movie?
      "Other Media"
    end
    
    def canonical_image_url
      if tv?
        episode_details.try(:[], "images").try(:first).try(:last)
      else
        movie_details.try(:[], "poster").presence
      end
    end
      
  end
  
end
