require 'rspec_extensions_collection/matchers/search_matcher'

module RSpecExtensionsCollection
  module Matchers

    # Asserts the search is made with the given fields for embedded Mongoid document
    # with the option specifying if the result if filtered by locale.
    # The method to test: search_embedded(keyword)
    #
    # Options:
    #
    # association_name: Name of the embedded document specified in the parent document.
    # args:             List of field name symbols. 
    #                   Last argument can be +Hash+ of options. 
    #                     :locale - Specifies the locale on which the filtering the search result is based on. "en" or "fr".
    #
    # Example:
    #
    # <tt>BlogPost.should search_embedded_by(:comments, :title, :content, :locale => I18n.locale.to_s)</tt>
    def search_embedded_by(association_name, *args)
      SearchEmbeddedMatcher.new(association_name, *args)
    end

    class SearchEmbeddedMatcher < SearchMatcher

      def initialize(association_name, *args)
        @association_name = association_name
        super(*args)
      end

      private
        # Executes the method in concern such as search:
        def execute
          @model_class.search_embedded(KEYWORD)
        end

        def create_model(field_with_keyword, locale = nil)
          # TODO: Replace with factory:
          parent_model = @model_class.create(:title => "Title", :content => "Content")
          
          embedded_model = parent_model.send(@association_name).build
          @fields.each do |field| 
            field_writer_symbol = "#{field}=".to_sym
            if field == field_with_keyword
              embedded_model.send(field_writer_symbol, FIELD_CONTENT_WITH_KEYWORD)
            else
              embedded_model.send(field_writer_symbol, FIELD_CONTENT_WITHOUT_KEYWORD)
            end
          end
          embedded_model.locale = locale if locale
          
          embedded_model.save
          
          parent_model.update_attributes(:locale => locale) if locale

          parent_model
        end

    end

  end
end