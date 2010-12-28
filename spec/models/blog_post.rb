class BlogPost
  include Mongoid::Document
  
  field :title
  field :content
  field :locale

  index :title
  index :locale
  
  before_validation :assign_current_locale

  validates :title, :presence => true
  validates :locale, :presence => true  

  embeds_many :comments, :class_name => "Blogs::Comment"

  scope :ordered, desc(:_id)  
  scope :in_current_locale, lambda { where(:locale => I18n.locale.to_s) }

  class << self

    def search(keyword)
      in_current_locale.where("this.title.match(/#{keyword}/i) || this.content.match(/#{keyword}/i)")
    end
    
    def search_embedded(keyword)
      in_current_locale.where("comments.content" => Regexp.new(keyword))
    end
  
  end

  private
    def assign_current_locale
      self.locale ||= I18n.locale.to_s
    end
  
end