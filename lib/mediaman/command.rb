module Mediaman
  
  require "thor"
  
  class CommandLine < Thor
    
    desc "sort <file>", "sorts the file according to its metadata"
    method_option :library, type: :string, aliases: "-l", desc: "Media library base folder to sort into.", default: "."
    def sort(path)
      library_document = LibraryDocument.from_path path
      library_document.library_path = File.expand_path options[:library]
      library_document.sort!
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