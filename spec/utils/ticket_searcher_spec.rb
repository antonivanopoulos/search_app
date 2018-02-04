[
  "lib/utils/ticket_searcher.rb",
].each { |f| require_relative "../../#{f}" }

require 'json'

RSpec.describe TicketSearcher do
  describe '.model_name' do
    it 'returns the name of the model were searching' do
      expect(described_class.model_name).to eq 'Ticket'
    end
  end

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

  describe '#search' do
    before do
      described_class.load_data(mock_data)
    end

    context 'strings' do
      it 'returns matches on string fields' do
        response = described_class.search('subject', 'A Catastrophe in Korea (North)')
        expect(response.map{ |u| u['_id'] }).to match_array(['436bf9b0-1147-4c0a-8439-6f79833bff5b'])
      end

      it 'doesnt return partial matches' do
        response = described_class.search('subject', 'A Catastrophe in Korea')
        expect(response.map{ |u| u['_id'] }).to be_empty
      end

      it 'matches empty values' do
        response = described_class.search('subject', '')
        expect(response.map{ |u| u['_id'] }).to match_array(['2217c7dc-7371-4401-8738-0a8a8aedc08d'])
      end
    end

    context 'integers' do
      it 'returns matches on integer fields' do
        response = described_class.search('submitter_id', 38)
        expect(response.map{ |u| u['_id'] }).to match_array(['436bf9b0-1147-4c0a-8439-6f79833bff5b'])
      end
    end

    context 'booleans' do
      it 'returns matches on boolean fields' do
        response = described_class.search('has_incidents', true)
        expect(response.map{ |u| u['_id'] }).to match_array(['2217c7dc-7371-4401-8738-0a8a8aedc08d'])
      end
    end

    context 'arrays' do
      it 'returns matches if array contains the value' do
        response = described_class.search('tags', 'Ohio')
        expect(response.map{ |u| u['_id'] }).to match_array(['436bf9b0-1147-4c0a-8439-6f79833bff5b'])
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
      response = described_class.find('436bf9b0-1147-4c0a-8439-6f79833bff5b')
      expect(response['_id']).to eq '436bf9b0-1147-4c0a-8439-6f79833bff5b'
    end

    it 'returns nil if a record cant be found' do
      response = described_class.find('436bf9b0-1147-4c0a-0000-6f79833bff5b')
      expect(response).to eq nil
    end
  end

  def mock_data
    json = File.read(File.expand_path('../data/tickets.json', File.dirname(__FILE__)))
    JSON.load(json)
  end
end
