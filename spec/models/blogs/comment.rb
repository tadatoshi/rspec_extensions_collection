module Blogs

  class Comment
    include Mongoid::Document

    field :content
    field :locale

    index :locale
  
    before_validation :assign_current_locale  

    validates :content, :presence => true
    validates :locale, :presence => true  
  
    embedded_in :blog_post, :inverse_of => :comments
  
    scope :ordered, asc(:_id)
    scope :in_current_locale, lambda { where(:locale => I18n.locale.to_s) }  
  
    private
      def assign_current_locale
        self.locale ||= I18n.locale.to_s
      end  
  
  end

end