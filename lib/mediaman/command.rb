module Mediaman
  
  require "thor"
  require "colorize"

  class CommandLine < Thor
    
    desc "add <file>", "sorts the file according to its metadata"
    method_option :library, type: :string, aliases: "-l", desc: "Media library base folder to sort into.", default: "."
    method_option :batch, type: :boolean, aliases: "-b", desc: "Adds each file or folder in the passed-in folder to the library. Not recursive.", default: false
    method_option :itunes, type: :boolean, desc: "Attempts to add the final file to iTunes.", default: false
    def add(input_path)

      # Find files for batch.
      if options[:batch] && File.directory?(input_path)
        paths = []
        Dir.glob File.join(input_path, "*") do |searchfile|
          case File.extname(searchfile)[1..-1]
          when /mov|mp4|m4v|avi|wmv|mkv/i then
            paths << searchfile
          else
            if File.directory?(searchfile)
              paths << searchfile
            end
          end
        end
      else
        # Just try the path if it's not a directory.
        paths = [input_path]
      end

      if paths.length > 0
        puts "Found #{paths.length} supported file#{paths.length == 1 ? "" : "s"}.".yellow
      else
        puts "No directories or supported files found.".red
      end

      # Add each
      for path in paths
        puts "Adding #{File.basename File.expand_path(path)}".green
        library_document = LibraryDocument.from_path path
        library_document.library_path = File.expand_path options[:library]
        puts "  -> #{library_document.video_files.size} video files / #{library_document.junk_files.size} junk files."
        library_document.move_to_library!
        library_document.save_and_apply_metadata!
        puts "  -> Destination: #{library_document.path}"
        if options[:itunes]
          library_document.add_to_itunes!
          puts "  -> Added to iTunes"
        end
      end

    end
    
    desc "metadata <file/directory/title>", "returns all the metadata discoverable about this file, title, or directory"
    def metadata(path)
      path = File.expand_path path
      if !File.exists?(path) && !File.directory?(path)
        name = path
      end
      if name
        doc = Mediaman::TemporaryDocument.from_name(name)
        puts doc.metadata.stringify_keys.to_yaml
      else
        doc = Document.from_path(path)
        doc.save_and_apply_metadata!
        puts "Metadata and image saved to #{doc.extras_path}".green
      end
    end
    
  end
  
end