module Types
    class DateType < GraphQL::Schema::Scalar
      description "Returns a Date formatted as 'YYYY-MM-DD'"
  
      def self.coerce_input(value, _context)
        Date.parse(value)
      end
  
      def self.coerce_result(value, _context)
        value.strftime("%Y-%m-%d")
      end
    end
  end