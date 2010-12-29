module RSpecExtensionsCollection
  module Matchers

    # Asserts the search is made with the given fields with the option specifying if the result if filtered by locale.
    # The method to test: search(keyword)
    #
    # Options:
    #
    # args: List of field name symbols. 
    #       Last argument can be +Hash+ of options. 
    #         :locale - Specifies the locale on which the filtering the search result is based on. "en" or "fr".
    #
    # Example:
    #
    # <tt>BlogPost.should search_by(:title, :content, :locale => I18n.locale.to_s)</tt>
    def search_by(*args)
      SearchMatcher.new(*args)
    end

    class SearchMatcher
      include MongoidModelHelpers

      KEYWORD = "temp"
      FIELD_CONTENT_WITH_KEYWORD = "This contains the keyword #{KEYWORD} and something else."
      FIELD_CONTENT_WITHOUT_KEYWORD = "Used for some data."
      LOCALES = ["en", "fr"]

      def initialize(*args)
        if args.try(:last).instance_of?(Hash)
          @locale = args.pop[:locale]
        end    
        @fields = args
      end

      def matches?(model_class)
        @model_class = model_class
        @model_class.delete_all
        create_models
        @search_result = execute
        execute_query_to_models(@search_result.asc(:_id)) == @matching_models
      end

      def failure_message_for_should
        "expected #{@model_class} to find #{@matching_models} but got #{execute_query_to_models(@search_result)}"
      end

      private
        # Executes the method in concern such as search:
        def execute
          @model_class.search(KEYWORD)
        end
      
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
          model = @model_class.new do |model_object|
            @fields.each do |field| 
              field_writer_symbol = "#{field}=".to_sym
              if field == field_with_keyword
                model_object.send(field_writer_symbol, FIELD_CONTENT_WITH_KEYWORD)
              else
                model_object.send(field_writer_symbol, FIELD_CONTENT_WITHOUT_KEYWORD)
              end
            end
            model_object.locale = locale if locale
          end
          model.save!
          model
        end
    
        def other_locale
          locales_copy = Array.new(LOCALES)
          locales_copy.delete(@locale)
          locales_copy.first
        end

    end

  end
end