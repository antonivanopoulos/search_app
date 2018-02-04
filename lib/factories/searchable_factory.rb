[
  "utils/organisation_searcher.rb",
  "utils/ticket_searcher.rb",
  "utils/user_searcher.rb",
].each { |f| require_relative "../#{f}" }

class SearchableFactory
  class << self
    def for(searchable)
      case searchable
      when :organisation
        OrganisationSearcher
      when :ticket
        TicketSearcher
      when :user
        UserSearcher
      end
    end
  end
end
