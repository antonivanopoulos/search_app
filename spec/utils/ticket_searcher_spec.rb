[
  "app/utils/ticket_searcher.rb",
].each { |f| require_relative "../../#{f}" }

RSpec.describe TicketSearcher do
  describe '.searchable_fields' do
    let(:searchable_fields) { %w(
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
    )}

    it 'returns a list of searchable fields' do
      expect(described_class.searchable_fields).to match_array(searchable_fields)
    end
  end
end
