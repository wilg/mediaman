module Mediaman
  
  require "thor"
  
  class CommandLine < Thor
    
    desc "add <file>", "sorts the file according to its metadata"
    method_option :library, type: :string, aliases: "-l", desc: "Media library base folder to sort into.", default: "."
    def add(path)
      library_document = LibraryDocument.from_path path
      library_document.library_path = File.expand_path options[:library]
      # puts "Sidecar path:"
      # puts library_document.library_sidecar_path
      puts "Video:"
      puts library_document.video_files
      puts "Junk:"
      puts library_document.junk_files
      puts "Files to move:"
      puts library_document.files_to_move.to_yaml
      puts "moving"
      puts library_document.move_to_library!
    end
    
    desc "metadata <file>", "returns all the metadata discoverable about this file or directory"
    def metadata(path)
      doc = Document.from_path(path)
      doc.extract_metadata!
      doc.save_sidecar!
      puts "Metadata saved to #{doc.sidecar_path}"
    end
    
  end
  
end