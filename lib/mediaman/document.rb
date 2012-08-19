require 'yaml'
require 'mini_subler'

module Mediaman

  # Represents an on-disk folder or file representation
  # of some kind of media.

  class Document
  
    def self.from_path(path)
      f = self.new
      f.path = File.expand_path path
      f
    end
    
    attr_accessor :path
    
    def metadata
      @metadata ||= begin
        metadata = {}
        metadata.merge!(local_metadata || {})
        metadata.merge!(remote_metadata || {})
        metadata.reject!{|k, v| v.blank?}
        Metadata.new(metadata)
      end
    end
    alias_method :extract_metadata!, :metadata
    
    def local_metadata
      @local_metadata ||= begin
        metadata = {}
        metadata.merge!(filename_metadata || {})
        metadata.merge!(video_metadata || {})
        metadata.merge!(sidecar_metadata || {})
        metadata.reject!{|k, v| v.blank?}
        Metadata.new(metadata)
      end
    end
    
    def local_metadata_fetched?
      @local_metadata.present?
    end
    
    def remote_metadata
      @remote_metadata ||= begin
         if local_metadata['movie']
           Metadata.new({'movie_details' => Trakt::Movie.new(title: local_metadata['name'], year: local_metadata['year'])})
         elsif local_metadata['tv']
           tv = Trakt::TVEpisode.new show_title: local_metadata['name'], season_number: local_metadata['season_number'], episode_number: local_metadata['episode_number']
           Metadata.new({'episode_details' => tv.to_hash, 'show_details' => tv.show.to_hash})
         end
      end
    end
    
    def filename
      File.basename(self.path, '.*')
    end
    
    def filename_metadata
      @filename_metadata ||= MediaFilename.new(self.filename).to_hash.try(:stringify_keys)
    end
    
    def video_metadata
      @video_metadata ||= MiniSubler::Command.vendored.get_metadata(self.video_files.first).try(:stringify_keys)
    end
        
    def sidecar_paths
      direct_sidecar  = File.join(File.dirname(self.path), File.basename(self.path, '.*') + ".meta.yml")
      library_sidecar = File.join(File.dirname(self.path), "Extras", File.basename(self.path, '.*'), "Metadata.yml")
      [direct_sidecar, library_sidecar]
    end
    
    def default_sidecar_path
      d = nil
      for path in sidecar_paths
        d = path if File.exists?(path)
      end
      d = sidecar_paths.first if d.nil?
      d
    end
    
    def sidecar_metadata
      @sidecar_metadata ||= begin
        y = {}
        for path in sidecar_paths
          if File.exists?(path)
            y.merge! YAML::load(File.open(path))
          end
        end
        y.stringify_keys
      end
    end
    
    def save_sidecar!(path = default_sidecar_path)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') {|f| f.write(self.metadata.stringify_keys.to_yaml) }
    end
    
    def video_files
      sort_junk! unless @video_files
      @video_files
    end
    
    def secondary_video_files
      if video_files && primary_video_file
        v = video_files.dup
        v.delete primary_video_file
        v
      else
        []
      end
    end
 
    def primary_video_file
      sort_junk! unless @video_files
      @primary_video_file ||= @video_files.sort{|a, b| File.size?(a) <=> File.size?(b) }.first
    end
    
    def junk_files
      sort_junk! unless @junk_files
      @junk_files
    end
        
    private
    
    def sort_junk!
      junk_files = []
      video_files = []
      if File.directory?(self.path)
        Dir.glob File.join(self.path, "*") do |file|
          filepath = file
          case File.extname(file)[1..-1]
          when /mov|mp4|m4v|avi|wmv|mkv/i then
            video_files << filepath
          else
            junk_files << filepath
          end
        end
      else
        video_files << self.path
      end
      @video_files = video_files
      @junk_files = junk_files
    end
    
  end

end