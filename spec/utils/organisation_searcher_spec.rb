[
  "lib/utils/organisation_searcher.rb",
].each { |f| require_relative "../../#{f}" }

require 'json'

RSpec.describe OrganisationSearcher do
  describe '.model_name' do
    it 'returns the name of the model were searching' do
      expect(described_class.model_name).to eq 'Organisation'
    end
  end

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

  describe '.search' do
    before do
      described_class.load_data(mock_data)
    end

    context 'strings' do
      it 'returns matches on string fields' do
        response = described_class.search('name', 'Enthaze')
        expect(response.map{ |u| u['_id'] }).to match_array([101])
      end

      it 'doesnt return partial matches' do
        response = described_class.search('name', 'Enthaz')
        expect(response.map{ |u| u['_id'] }).to be_empty
      end

      it 'matches empty values' do
        response = described_class.search('details', '')
        expect(response.map{ |u| u['_id'] }).to match_array([103])
      end
    end

    context 'integers' do
      it 'returns matches on integer fields' do
        response = described_class.search('_id', 101)
        expect(response.map{ |u| u['_id'] }).to match_array([101])
      end
    end

    context 'booleans' do
      it 'returns matches on boolean fields' do
        response = described_class.search('shared_tickets', false)
        expect(response.map{ |u| u['_id'] }).to match_array([101, 102])
      end
    end

    context 'arrays' do
      it 'returns matches if array contains the value' do
        response = described_class.search('tags', 'Fulton')
        expect(response.map{ |u| u['_id'] }).to match_array([101])
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
      response = described_class.find(101)
      expect(response['_id']).to eq 101
    end

    it 'returns nil if a record cant be found' do
      response = described_class.find(100)
      expect(response).to eq nil
    end
  end

  def mock_data
    json = File.read(File.expand_path('../data/organizations.json', File.dirname(__FILE__)))
    JSON.load(json)
  end
end
