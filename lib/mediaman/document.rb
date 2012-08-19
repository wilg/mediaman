require 'yaml'
require 'mini_subler'
require "open-uri"

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
    
    def rebase!(path)
      self.path = path
      @primary_video_file = nil
      @junk_files = nil
      @video_files = nil
    end
    
    def save_and_apply_metadata!
      extract_metadata!
      save_sidecar!
      download_image!
      # Download image.
      # Add metadata to file.
      # Rewrap mxf to mp4.
    end
    
    def download_image!
      if !File.exists?(artwork_path) && metadata.canonical_image_url.present?
        FileUtils.mkdir_p(File.dirname(artwork_path))
        open(metadata.canonical_image_url) {|f|
           File.open(artwork_path, "wb") do |file|
             file.puts f.read
           end
        }
      end
    end
    
    def artwork_path
      extra_path "Artwork#{metadata.canonical_image_url.present? ? File.extname(metadata.canonical_image_url) : ".jpg"}"
    end
    
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
    
    def standalone_extras_path
      File.join(File.dirname(self.path), File.basename(self.path, '.*') + " Extras")
    end
    
    def library_extras_path
      File.join(File.dirname(self.path), "Extras", File.basename(self.path, '.*'))
    end
        
    def extras_paths
      [library_extras_path, standalone_extras_path]
    end
    
    def extras_path
      d = nil
      for path in extras_paths.uniq
        d = path if File.exists?(path)
      end
      d = extras_paths.last if d.nil?
      d
    end
    
    def extra_path(file)
      File.join extras_path, file
    end
    
    def extra_paths(file)
      extras_paths.uniq.map do |x|
        File.join x, file
      end
    end
        
    def sidecar_metadata
      @sidecar_metadata ||= begin
        y = {}
        extra_paths("Metadata.yml").each do |path|
          if File.exists?(path)
            y.merge! YAML::load(File.open(path))
          end
        end
        y.stringify_keys
      end
    end
    
    def save_sidecar!(path = extra_path("Metadata.yml"))
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