[
  "lib/utils/user_searcher.rb",
].each { |f| require_relative "../../#{f}" }

require 'json'

RSpec.describe UserSearcher do
  describe '.model_name' do
    it 'returns the name of the model were searching' do
      expect(described_class.model_name).to eq 'User'
    end
  end

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

  describe '#search' do
    before do
      described_class.load_data(mock_data)
    end

    context 'strings' do
      it 'returns matches on string fields' do
        response = described_class.search('name', 'Francisca Rasmussen')
        expect(response.map{ |u| u['_id'] }).to match_array([1])
      end

      it 'doesnt return partial matches' do
        response = described_class.search('name', 'Francisca')
        expect(response.map{ |u| u['_id'] }).to be_empty
      end

      it 'matches empty values' do
        response = described_class.search('signature', '')
        expect(response.map{ |u| u['_id'] }).to match_array([3])
      end
    end

    context 'integers' do
      it 'returns matches on integer fields' do
        response = described_class.search('_id', 1)
        expect(response.map{ |u| u['_id'] }).to match_array([1])
      end
    end

    context 'booleans' do
      it 'returns matches on boolean fields' do
        response = described_class.search('active', true)
        expect(response.map{ |u| u['_id'] }).to match_array([1, 2])
      end
    end

    context 'arrays' do
      it 'returns matches if array contains the value' do
        response = described_class.search('tags', 'Springville')
        expect(response.map{ |u| u['_id'] }).to match_array([1])
      end

      it 'doesnt return records not containing the value' do
        response = described_class.search('tags', 'Purple')
        expect(response.map{ |u| u['_id'] }).to be_empty
      end
    end
  end

  describe '.find' do
    before do
      described_class.load_data(mock_data)
    end

    it 'returns a record matching on id' do
      response = described_class.find('1')
      expect(response['_id']).to eq 1
    end

    it 'returns nil if a record cant be found' do
      response = described_class.find(5000)
      expect(response).to eq nil
    end
  end

  def mock_data
    json = File.read(File.expand_path('../data/users.json', File.dirname(__FILE__)))
    JSON.load(json)
  end
end
