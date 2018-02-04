module Searcher
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def initialize(data)
      @data = data
    end

    def search(field, value)
      if array_field?(field)
        data.select{ |u| u[field].include?(value) }
      else
        data.select{ |u| u[field] == value }
      end
    end

    private

    def array_field?(field)
      self.class.array_fields.include?(field)
    end

    attr_reader :data
  end

  module ClassMethods
    def searchable_fields
      []
    end

    def array_fields
      []
    end
  end
end
