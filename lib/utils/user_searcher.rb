require_relative 'searcher'

class UserSearcher
  include Searcher

  class << self
    def model_name
      'User'
    end

    def find_associations(result)
      result.tap do |r|
        organisation = OrganisationSearcher.find(r['organization_id'])
        if organisation
          r['organisation_name'] = organisation['name']
        end

        TicketSearcher.search('submitter_id', r['_id']).each_with_index do |t, i|
          r["submitted_ticket_#{i}"] = t['subject']
        end

        TicketSearcher.search('assignee_id', r['_id']).each_with_index do |t, i|
          r["assigned_ticket_#{i}"] = t['subject']
        end
      end
    end

    def searchable_fields
      %w(
        _id
        url
        external_id
        name
        alias
        created_at
        active
        verified
        shared
        locale
        timezone
        last_login_at
        email
        phone
        signature
        organization_id
        tags
        suspended
        role
      )
    end

    def int_fields
      %w(
        _id
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

