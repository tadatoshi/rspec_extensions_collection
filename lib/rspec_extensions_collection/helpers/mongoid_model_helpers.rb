module RSpecExtensionsCollection
  module Matchers
    module MongoidModelHelpers
  
      # Mongoid executes query only when it's needed. Until then, it just creates Criteria object. 
      # For the purpose of test, this method gets the result models array from Criteria object as usually done in for loop in view.
      def execute_query_to_models(result_array_mongoid_criteria)
        result_array_mongoid_criteria.map { |model| model }
      end
  
    end
  end
end