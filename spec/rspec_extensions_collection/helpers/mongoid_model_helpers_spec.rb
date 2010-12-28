require 'spec_helper'

describe "MongoidModelHelpers" do
  include RSpecExtensionsCollection::Matchers::MongoidModelHelpers

  describe BlogPost do
    
    before(:each) do
      BlogPost.delete_all
    end
    
    after(:each) do
      BlogPost.delete_all
    end    
    
    context "Scope" do

      it "should have the current locale and be ordered by id" do     

        blog_post_1 = BlogPost.create(:locale => "fr", :title => "First blog entry", :content => "This is the first entry")
        blog_post_2 = BlogPost.create(:locale => "fr", :title => "Second blog entry", :content => "This is the second entry")
        blog_post_3 = BlogPost.create(:locale => "en", :title => "Third blog entry", :content => "This is the third entry")
        blog_post_4 = BlogPost.create(:locale => "fr", :title => "Fourth blog entry", :content => "This is the fourth entry")
        blog_post_5 = BlogPost.create(:locale => "en", :title => "Fifth blog entry", :content => "This is the fifth entry")

        I18n.locale = "en"
        execute_query_to_models(BlogPost.in_current_locale.ordered).should == [blog_post_5, blog_post_3]
        I18n.locale = "fr"
        execute_query_to_models(BlogPost.in_current_locale.ordered).should == [blog_post_4, blog_post_2, blog_post_1]      

      end

    end
    
  end
  
end