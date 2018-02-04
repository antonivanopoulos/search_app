[
  "utils/organisation_searcher.rb",
  "utils/ticket_searcher.rb",
  "utils/user_searcher.rb",
].each { |f| require_relative "#{f}" }

module SearchApp
  class << self
    def start
      print_welcome

      while true
        print_instructions
        input = get_input

        case input
        when SEARCH_OPTION
          puts "search"
          puts ""
        when LIST_OPTION
          print_search_fields
        when QUIT_OPTION
          print_goodbye
          break
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
