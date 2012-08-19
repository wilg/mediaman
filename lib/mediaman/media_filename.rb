module Mediaman

  class MediaFilename
    
    attr_accessor :filename
  
    def initialize(filename)        
      self.filename = filename
      parse_name!
      formatted_name # To init year
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
  
    def parse_name!
      name = self.filename + ".mov"
    
      # Normal matching
      normal_matches = name.match(/^([a-zA-Z0-9.]*)\.S([0-9]{1,2})E([0-9]{1,2}).*$/i)
      if normal_matches
        @item_name = normal_matches[1]
        @season = normal_matches[2].to_i
        @episode = normal_matches[3].to_i
      end
    
      unless @item_name && @season && @episode
        # Mythbusters hack
        mythbusters_matches = name.match(/(myth.*)([0-9][0-9])([0-9][0-9])/i)
        if mythbusters_matches && mythbusters_matches[1].downcase.include?("myth")
          @item_name = "Mythbusters"
          @season = mythbusters_matches[2].to_i
          @episode = mythbusters_matches[3].to_i
        end
      end
    
    end
    
    def raw_name
      @item_name || self.filename
    end
    
    def formatted_name
      perioded_name = []
      
      name = 
    
      name_string = raw_name.gsub("'", "")
      name_string = raw_name.gsub(";", "")
        
      splitsies = name_string.split(/[ -.\[\]]/)
      splitsies.each_index do |i|
        x =  splitsies[i].split(" ")
        x = x.split("+")
        x = x.split("_")
        x = x.split("[")
        x = x.split("]")
        splitsies[i] = x
      end
    
      name_done = false
      i = 0
      for item in splitsies.flatten
        int = item.to_i
        if (1900..Time.now.year + 3).cover?(int) && i > 0
          @year = int
          name_done = true
        elsif item == "720p"
          name_done = true
        else
          perioded_name << item unless name_done
        end
        i += 1
      end    
      name = perioded_name.join(" ")
    
      # Hacks
      name.gsub! /Extended( Version)/i, ""
    
      name
    end
  
    def title_slug
      slug = formatted_name.parameterize
    
      #Hacks
      slug = "the-newsroom-2012" if slug == "the-newsroom"
    
      slug
    end

    def season
      @season
    end

    def episode
      @episode
    end

    def tv?
      episode.present? && season.present?
    end
  
    def year
      @year
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
  
    def debug
      "name: #{name}, formatted_name: #{formatted_name}, slug: #{slug}, season: #{season}, episode: #{episode}, hd?: #{hd?}, tv?: #{tv?}, string: #{string}"
    end
  
  end
end