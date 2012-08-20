module Mediaman
  
  class TemporaryDocument < Document
    
    def self.from_name(name)
      f = self.new
      f.path = name
      f
    end
    
    def metadata
      @metadata ||= begin
        metadata = {}
        metadata.merge!(filename_metadata || {})
        metadata.merge!(remote_metadata || {})
        metadata.reject!{|k, v| v.blank?}
        Metadata.new(metadata)
      end
    end
    
  end
      
end