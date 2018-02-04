module Searcher
  UNDEFINED_TYPE = -1
  INT_TYPE = 1
  STRING_TYPE = 2
  BOOLEAN_TYPE = 3
  ARRAY_TYPE = 4

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def load_data(data)
      @data = data
    end

    def find(id)
      search('_id', id).first
    end

    def search(field, value)
      converted_value = convert_type(field, value)

      if array_field?(field)
        data.select{ |r| r[field].include?(converted_value) }
      else
        data.select{ |r| r[field] == converted_value }
      end
    end

    private

    def int_field?(field)
      int_fields.include?(field)
    end

    def string_field?(field)
      string_fields.include?(field)
    end

    def boolean_field?(field)
      boolean_fields.include?(field)
    end

    def array_field?(field)
      array_fields.include?(field)
    end

    def valid_field?(field)
      searchable_fields.include?(field)
    end

    private

    attr_accessor :data
    @data = nil

    def searchable_fields
      []
    end

    def int_fields
      []
    end

    def string_fields
      []
    end

    def boolean_fields
      []
    end

    def array_fields
      []
    end

    def field_type(field)
      return INT_TYPE if int_field?(field)
      return STRING_TYPE if string_field?(field)
      return BOOLEAN_TYPE if boolean_field?(field)
      return ARRAY_TYPE if array_field?(field)
      UNDEFINED_TYPE
    end

    def convert_type(field, value)
      case field_type(field)
      when INT_TYPE
        value.to_i
      when BOOLEAN_TYPE
        value == 'true'
      when STRING_TYPE, ARRAY_TYPE
        value
      else
        value
      end
    end
  end
end
