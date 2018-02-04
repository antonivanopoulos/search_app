require_relative 'searcher'

class TicketSearcher
  include Searcher

  class << self
    def model_name
      'Ticket'
    end

    def searchable_fields
      %w(
        _id
        url
        external_id
        created_at
        type
        subject
        description
        priority
        status
        submitter_id
        assignee_id
        organization_id
        tags
        has_incidents
        due_at
        via
      )
    end

    def array_fields
      %w(
        tags
      )
    end
  end
end
