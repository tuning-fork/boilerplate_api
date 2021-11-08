module Types
    class DateTimeType < Types::BaseScalar
      description "Returns a DateTime as iso8601"
  
      def self.coerce_input(value, _context)
        DateTime.parse(value.to_s)
      end
  
      def self.coerce_result(value, _context)
        value.to_datetime.iso8601
      end
    end
  end