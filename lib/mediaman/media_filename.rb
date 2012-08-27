module Mediaman

  require "to_name"

  class MediaFilename

    attr_accessor :filename
  
    def initialize(filename)        
      self.filename = filename
      @parsed_name = self.to_name
    end

    def to_name
      fn = ToName.to_name(filename)
      {
        name: fn.name,
        year: fn.year,
        raw_name: fn.raw_name,
        location: fn.location,
        season_number: fn.series,
        episode_number: fn.episode
      }
    end
    
    def to_hash
      {
        filename: self.filename,
        name: self.formatted_name,
        raw_name: self.raw_name,
        year: self.year,
        tv: self.tv?,
        movie: self.movie?,
        season_number: self.season,
        episode_number: self.episode,
        hd: self.hd?,
        hd_format: self.hd_format
      }
    end
  
    def raw_name
      self.filename
    end
    
    def formatted_name
      name = @parsed_name[:name]
    
      # Hacks
      name.gsub! /Extended( Version)( Edition)/i, ""
    
      name
    end
  
    def title_slug
      slug = formatted_name.parameterize
    
      #Hacks
      slug = "the-newsroom-2012" if slug == "the-newsroom"
    
      slug
    end

    def season
      @parsed_name[:season_number]
    end

    def episode
      @parsed_name[:episode_number]
    end

    def tv?
      episode.present? && season.present?
    end
  
    def year
      @parsed_name[:year]
    end
  
    def movie?
      !tv? && year.present?
    end
  
    def hd?
      self.filename.include?("720p") || self.filename.include?("1080p") || self.filename.include?("HDTV")  || self.filename.include?("HDRip")
    end
  
    def h264?
      (self.filename =~ /m4v|mp4|h264|x264/i).present?
    end
  
    def hd_format
      return "SD" unless hd?
      if self.filename.include?("720p")
        "720p"
      elsif self.filename.include?("1080p")
        "1080p"
      else
        "HD"
      end
    end
  
    def to_s
      formatted_name
    end

  end
end