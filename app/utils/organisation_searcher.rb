require_relative 'searcher'

class OrganisationSearcher
  include Searcher

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
