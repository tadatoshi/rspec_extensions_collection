require 'spec_helper'

describe "SearchMatcher" do

  describe BlogPost do
    
    before(:each) do
      BlogPost.delete_all
      I18n.locale = "en"
    end
    
    after(:each) do
      BlogPost.delete_all
      I18n.locale = "en"
    end    
    
    context "Search" do

      it "should find blog_post with a keyword using custom matcher" do
        
        BlogPost.should search_by(:title, :content, :locale => I18n.locale.to_s)
        
      end

    end
    
  end
  
end