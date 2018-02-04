require_relative 'searcher'

class TicketSearcher
  include Searcher

  class << self
    def model_name
      'Ticket'
    end

    def find_associations(result)
      result.tap do |r|
        submitter = UserSearcher.find(r['submitter_id'])
        if submitter
          r['submitter_name'] = submitter['name']
        end

        assignee = UserSearcher.find(r['submitter_id'])
        if assignee
          r['assignee_name'] = assignee['name']
        end

        organisation = OrganisationSearcher.find(r['organization_id'])
        if organisation
          r['organisation_name'] = organisation['name']
        end
      end
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

    def int_fields
      %w(
        submitter_id
        assignee_id
        organization_id
      )
    end

    def array_fields
      %w(
        tags
      )
    end
  end
end
