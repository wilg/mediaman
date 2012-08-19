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
    
    def canonical_description
      if tv?
        episode_details.try(:[], "overview").presence
      else
        movie_details.try(:[], "overview").presence
      end
    end
    
    def canonical_rating
      movie_details.try(:[], "certification").presence
    end
    
    def canonical_year
      movie_details.try(:[], "year").presence || year.presence
    end
    
    def to_subler_hash
      h = {}
      if movie?
        h[:name] = canonical_movie_title
        h[:media_kind] = "Movie"
        h[:rating] = canonical_rating if canonical_rating
        h[:year] = canonical_year if canonical_year
      end
      if tv?
        h[:name] = canonical_episode_name
        h[:tv_show] = canonical_show_name
        h[:album] = canonical_show_name
        h[:tv_episode_id] = episode_id
        h[:tv_episode_number] = episode_number
        h[:tv_season] = season_number
        h[:track_number] = "#{episode_number}/0"
        h[:media_kind] = "TV Show"
      end
      h[:description] = canonical_description if canonical_description.present?
      h[:hd_video] = true if hd?
      h
    end
      
  end
  
end
