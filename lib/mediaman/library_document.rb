module Mediaman

  # Represents an on-disk folder or file representation
  # of some kind of media.
  #
  # This type is part of a "library" folder strucure.

  class LibraryDocument < Document
  
    attr_accessor :library_path
    
    def sort!
      # Sorts based on media info.
    end
 
  end

end