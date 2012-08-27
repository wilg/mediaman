module Mediaman
  
  require "thor"
  
  class CommandLine < Thor
    
    desc "add <file>", "sorts the file according to its metadata"
    method_option :library, type: :string, aliases: "-l", desc: "Media library base folder to sort into.", default: "."
    # method_option :batch, type: :boolean, aliases: "-b", desc: "Adds each file or folder in the passed-in folder to the library.", default: false
    method_option :itunes, type: :boolean, desc: "Attempts to add the final file to iTunes.", default: false
    def add(path)
      puts "Adding #{File.basename File.expand_path(path)}..."
      library_document = LibraryDocument.from_path path
      library_document.library_path = File.expand_path options[:library]
      puts "Found #{library_document.video_files.size} video files and #{library_document.junk_files.size} junk files."
      library_document.move_to_library!
      library_document.save_and_apply_metadata!
      puts "New location: #{library_document.path}."
      if options[:itunes]
        library_document.add_to_itunes!
        puts "Added to iTunes!"
      end
    end
    
    desc "metadata <file>", "returns all the metadata discoverable about this file or directory"
    def metadata(path)
      doc = Document.from_path(path)
      doc.save_and_apply_metadata!
      puts "Metadata and image saved to #{doc.extras_path}"
    end
    
  end
  
end