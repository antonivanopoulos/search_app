[
  "lib/factories/searchable_factory.rb",
].each { |f| require_relative "../../#{f}" }

RSpec.describe SearchableFactory do
  describe '.for' do
    it 'returns a searcher for users' do
      expect(SearchableFactory.for(:user)).to eq UserSearcher
    end

    it 'returns a searcher for tickets' do
      expect(SearchableFactory.for(:ticket)).to eq TicketSearcher
    end

    it 'returns a searcher for organisations' do
      expect(SearchableFactory.for(:organisation)).to eq OrganisationSearcher
    end
  end
end
