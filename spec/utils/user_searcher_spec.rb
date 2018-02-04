[
  "app/utils/user_searcher.rb",
].each { |f| require_relative "../../#{f}" }

RSpec.describe UserSearcher do
  describe '.searchable_fields' do
    let(:searchable_fields) { %w(
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
    )}

    it 'returns a list of searchable fields' do
      expect(described_class.searchable_fields).to match_array(searchable_fields)
    end
  end
end
