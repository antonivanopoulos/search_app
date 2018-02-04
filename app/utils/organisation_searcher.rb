class OrganisationSearcher
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

  class << self
    def searchable_fields
      %w(
        _id
        url
        external_id
        name
        domain_names
        created_at
        details
        shared_tickets
        tags
      )
    end

    def array_fields
      %w(
        domain_names
        tags
      )
    end
  end
end
