[
  "factories/searchable_factory.rb",
  "utils/organisation_searcher.rb",
  "utils/ticket_searcher.rb",
  "utils/user_searcher.rb",
].each { |f| require_relative "#{f}" }

require 'json'

module SearchApp
  class << self
    def start
      load_data
      print_welcome

      while true
        print_instructions
        option = get_input

        case option
        when SEARCH_OPTION
          get_search_input
        when LIST_OPTION
          print_search_fields
        when QUIT_OPTION
          print_goodbye
          exit
        else
          puts "wrong"
          puts ""
        end
      end
    end

    private

    SEARCH_OPTION = '1'.freeze
    LIST_OPTION = '2'.freeze
    QUIT_OPTION = 'quit'.freeze

    SEARCH_USER = '1'.freeze
    SEARCH_TICKET = '2'.freeze
    SEARCH_ORGANISATION = '3'.freeze

    def load_data
      organisation_json = JSON.load(File.read('data/organizations.json'))
      ticket_json = JSON.load(File.read('data/tickets.json'))
      user_json = JSON.load(File.read('data/users.json'))

      OrganisationSearcher.load_data(organisation_json)
      TicketSearcher.load_data(ticket_json)
      UserSearcher.load_data(user_json)
    end

    def get_input
      gets.chomp.downcase
    end

    def print_welcome
      puts "Welcome to Zendesk Search"
      puts "Type 'quit' to exit at any time, press 'Enter' to continue"
      puts ""
    end

    def print_instructions
      puts "Select search options:"
      puts "  * Press 1 to search Zendesk"
      puts "  * Press 2 to view a list of searchable fields"
      puts "  * Type 'quit' to close Zendesk Search"
      puts ""
    end

    def get_search_input
      puts "Select 1) Users or 2) Tickets or 3) Organisations"

      option = get_input
      factory = factory_for(option)

      unless factory.nil?
        searcher = SearchableFactory.for(factory)

        puts "Enter search term"
        field = get_input

        puts "Enter search value"
        value = get_input

        puts "Searching #{searcher.model_name.downcase}s for #{field} with a value of #{value}"
        results = searcher.search(field, value).map { |r| searcher.find_associations(r) }

        if results.any?
          print_divider
          print_results(results)
          puts ""
        else
          puts "No results found"
          puts ""
        end
      else
        puts "Invalid parameters"
      end
    end

    def print_results(results)
      results.each do |result|
        result.each do |key, value|
          puts sprintf("%-20s%s", key, value)
        end
      end
    end

    def factory_for(option)
      case option
      when SEARCH_USER
        :user
      when SEARCH_TICKET
        :ticket
      when SEARCH_ORGANISATION
        :organisation
      else
        nil
      end
    end

    def print_search_fields
      [OrganisationSearcher, TicketSearcher, UserSearcher].map do |s|
        print_divider
        puts "Search #{s.model_name} with:"
        puts s.searchable_fields
      end
      puts ""
    end

    def print_divider
      puts "--------------------------------------------------"
    end

    def print_goodbye
      puts ""
      puts "Exiting. Goodbye!"
    end
  end
end
