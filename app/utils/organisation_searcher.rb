class OrganisationSearcher
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
  end
end
