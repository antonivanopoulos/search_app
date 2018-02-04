[
  "app/utils/organisation_searcher.rb",
].each { |f| require_relative "../../#{f}" }

RSpec.describe OrganisationSearcher do
  describe '.searchable_fields' do
    let(:searchable_fields) { %w(
      _id
      url
      external_id
      name
      domain_names
      created_at
      details
      shared_tickets
      tags
    )}

    it 'returns a list of searchable fields' do
      expect(described_class.searchable_fields).to match_array(searchable_fields)
    end
  end
end
