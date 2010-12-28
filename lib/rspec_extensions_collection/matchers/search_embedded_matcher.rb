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

    class SearchEmbeddedMatcher
      include MongoidModelHelpers

      KEYWORD = "temp"
      FIELD_CONTENT_WITH_KEYWORD = "This contains the keyword #{KEYWORD} and something else."
      FIELD_CONTENT_WITHOUT_KEYWORD = "Used for some data."
      LOCALES = ["en", "fr"]

      def initialize(association_name, *args)
        @association_name = association_name
        if args.try(:last).instance_of?(Hash)
          @locale = args.pop[:locale]
        end    
        @fields = args
      end

      def matches?(model_class)
        @model_class = model_class
        @model_class.delete_all
        create_models
        @search_result = model_class.search_embedded(KEYWORD)
        execute_query_to_models(@search_result) == @matching_models
      end

      def failure_message_for_should
        "expected #{@model_class} to find #{@matching_models} but got #{execute_query_to_models(@search_result)}"
      end

      private
        def create_models
          @all_models = []
          @matching_models = []

          (0..@fields.size-1).each do |index|
            if @locale
              model_with_matching_locale = create_model(@fields[index], @locale)
              @matching_models << model_with_matching_locale
              @all_models << model_with_matching_locale
          
              model_with_other_locale = create_model(@fields[index], other_locale)
              @all_models << model_with_other_locale
            else
              model = create_model(@fields[index])
              @matching_models << model
              @all_models << model
            end
          end
      
          if @locale
            LOCALES.each { |locale| @all_models << create_model(nil, locale) }
          else
            @all_models << create_model(nil)
          end
        end

        def create_model(field_with_keyword, locale = nil)
          parent_model = @model_class.create(:title => "Title", :content => "Content")
          
          # The following doesn't work:
          # embedded_model = parent_model.send(@association_name).build do |model_object|
          #   @fields.each do |field| 
          #     field_writer_symbol = "#{field}=".to_sym
          #     if field == field_with_keyword
          #       model_object.send(field_writer_symbol, FIELD_CONTENT_WITH_KEYWORD)
          #     else
          #       model_object.send(field_writer_symbol, FIELD_CONTENT_WITHOUT_KEYWORD)
          #     end
          #   end
          #   model_object.locale = locale if locale
          # end
          
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

        def other_locale
          locales_copy = Array.new(LOCALES)
          locales_copy.delete(@locale)
          locales_copy.first
        end

    end

  end
end