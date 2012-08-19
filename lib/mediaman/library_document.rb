module Mediaman

  # Represents an on-disk folder or file representation
  # of some kind of media.
  #
  # This type is part of a "library" folder strucure.

  class LibraryDocument < Document
  
    attr_accessor :library_path
    
    def move_to_library!
      files_to_move.each do |original_file, new_file|
        FileUtils.mkdir_p(File.dirname(new_file))
        FileUtils.move(original_file, new_file)
      end
      save_sidecar! library_sidecar_path
    end
    
    def files_to_move
      files = {}
      files[primary_video_file] = library_file_path if primary_video_file
      for file in junk_files + secondary_video_files
        files[file] = File.join library_junk_path, File.basename(file)
      end
      files
    end
    
    def library_filename
      if metadata.tv? && metadata.canonical_show_name
        s = "#{metadata.canonical_show_name}/Season #{metadata.season_number}/#{metadata.episode_id}"
        s << " - #{metadata.canonical_episode_name}" if metadata.canonical_episode_name.present?
        s
      elsif metadata.year.present?
        "#{metadata.canonical_movie_title.gsub(":", " - ")} (#{metadata.year})"
      else
        metadata.name
      end
    end
    
    def library_versioned_filename(n = 1)
      extension = File.extname(primary_video_file)[1..-1]
      old_filename  = File.basename(primary_video_file, '.*')
      v = ""
      v = " v#{n}" if n > 1
      if library_filename.present?
        "#{library_filename}#{v}.#{extension}"
      else
        "#{old_filename}#{v}.#{extension}"
      end
    end
    
    def library_file_path
      @library_file_path ||= begin
        base_path = File.join File.expand_path(library_path), metadata.library_category
        i = 1
        dup = true
        while dup == true
          path = File.join base_path, library_versioned_filename(i)
          if File.exists?(path) || File.directory?(path)
            i = i + 1
            dup = true
          else
            dup = false
          end
        end
        path
      end
    end
    
    def library_extras_path
      File.join File.dirname(library_file_path), "Extras", File.basename(library_file_path, '.*')
    end
    
    def library_junk_path
      File.join library_extras_path, "Junk"
    end
    
    def library_sidecar_path
      File.join library_extras_path, "Metadata.yml"
    end
    
  end

end