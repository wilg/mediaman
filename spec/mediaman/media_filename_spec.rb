require 'spec_helper'  
  
describe Mediaman::MediaFilename do  
  
  def parse(filename)
    Mediaman::MediaFilename.new(filename).to_hash
  end
  
  describe "correctly parses" do
  
    it "The Descendants" do
      h = parse("The Descendants")
      h[:name].should == "The Descendants"
    end
    
    it "The.Newsroom.S01E01.COOOLNESS" do
      h = parse("The.Newsroom.S01E01.COOOLNESS")
      h[:name].should == "The Newsroom"
      h[:tv].should be_true
      h[:episode_number].should == 1
    end
    
    it "John.Adams.S01E01.720p.HDTV.x264" do
      h = parse("John.Adams.S01E01.720p.HDTV.x264")
      h[:name].should == "John Adams"
    end
  
    it "John Adams.S01E01.720p.HDTV.x264" do
      h = parse("John Adams.S01E01.720p.HDTV.x264")
      h[:name].should == "John Adams"
    end
  
  end
  
  
end  
