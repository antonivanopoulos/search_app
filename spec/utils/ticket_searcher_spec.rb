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
    let(:json) {
      <<-JSON
        [
          {
            "_id": "436bf9b0-1147-4c0a-8439-6f79833bff5b",
            "url": "http://initech.zendesk.com/api/v2/tickets/436bf9b0-1147-4c0a-8439-6f79833bff5b.json",
            "external_id": "9210cdc9-4bee-485f-a078-35396cd74063",
            "created_at": "2016-04-28T11:19:34 -10:00",
            "type": "incident",
            "subject": "A Catastrophe in Korea (North)",
            "description": "Nostrud ad sit velit cupidatat laboris ipsum nisi amet laboris ex exercitation amet et proident. Ipsum fugiat aute dolore tempor nostrud velit ipsum.",
            "priority": "high",
            "status": "pending",
            "submitter_id": 38,
            "assignee_id": 24,
            "organization_id": 116,
            "tags": [
              "Ohio",
              "Pennsylvania",
              "American Samoa",
              "Northern Mariana Islands"
            ],
            "has_incidents": false,
            "due_at": "2016-07-31T02:37:50 -10:00",
            "via": "web"
          },
          {
            "_id": "1a227508-9f39-427c-8f57-1b72f3fab87c",
            "url": "http://initech.zendesk.com/api/v2/tickets/1a227508-9f39-427c-8f57-1b72f3fab87c.json",
            "external_id": "3e5ca820-cd1f-4a02-a18f-11b18e7bb49a",
            "created_at": "2016-04-14T08:32:31 -10:00",
            "type": "incident",
            "subject": "A Catastrophe in Micronesia",
            "description": "Aliquip excepteur fugiat ex minim ea aute eu labore. Sunt eiusmod esse eu non commodo est veniam consequat.",
            "priority": "low",
            "status": "hold",
            "submitter_id": 71,
            "assignee_id": 38,
            "organization_id": 112,
            "tags": [
              "Puerto Rico",
              "Idaho",
              "Oklahoma",
              "Louisiana"
            ],
            "has_incidents": false,
            "due_at": "2016-08-15T05:37:32 -10:00",
            "via": "chat"
          },
          {
            "_id": "2217c7dc-7371-4401-8738-0a8a8aedc08d",
            "url": "http://initech.zendesk.com/api/v2/tickets/2217c7dc-7371-4401-8738-0a8a8aedc08d.json",
            "external_id": "3db2c1e6-559d-4015-b7a4-6248464a6bf0",
            "created_at": "2016-07-16T12:05:12 -10:00",
            "type": "problem",
            "subject": "",
            "description": "Ipsum fugiat voluptate reprehenderit cupidatat aliqua dolore consequat. Consequat ullamco minim laboris veniam ea id laborum et eiusmod excepteur sint laborum dolore qui.",
            "priority": "normal",
            "status": "closed",
            "submitter_id": 9,
            "assignee_id": 65,
            "organization_id": 105,
            "tags": [
              "Massachusetts",
              "New York",
              "Minnesota",
              "New Jersey"
            ],
            "has_incidents": true,
            "due_at": "2016-08-06T04:16:06 -10:00",
            "via": "web"
          }
        ]
      JSON
    }

    let(:data) { JSON.load(json) }

    context 'strings' do
      it 'returns matches on string fields' do
        response = described_class.new(data).search('subject', 'A Catastrophe in Korea (North)')
        expect(response.map{ |u| u['_id'] }).to match_array(['436bf9b0-1147-4c0a-8439-6f79833bff5b'])
      end

      it 'doesnt return partial matches' do
        response = described_class.new(data).search('subject', 'A Catastrophe in Korea')
        expect(response.map{ |u| u['_id'] }).to be_empty
      end

      it 'matches empty values' do
        response = described_class.new(data).search('subject', '')
        expect(response.map{ |u| u['_id'] }).to match_array(['2217c7dc-7371-4401-8738-0a8a8aedc08d'])
      end
    end

    context 'integers' do
      it 'returns matches on integer fields' do
        response = described_class.new(data).search('submitter_id', 38)
        expect(response.map{ |u| u['_id'] }).to match_array(['436bf9b0-1147-4c0a-8439-6f79833bff5b'])
      end
    end

    context 'booleans' do
      it 'returns matches on boolean fields' do
        response = described_class.new(data).search('has_incidents', true)
        expect(response.map{ |u| u['_id'] }).to match_array(['2217c7dc-7371-4401-8738-0a8a8aedc08d'])
      end
    end

    context 'arrays' do
      it 'returns matches if array contains the value' do
        response = described_class.new(data).search('tags', 'Ohio')
        expect(response.map{ |u| u['_id'] }).to match_array(['436bf9b0-1147-4c0a-8439-6f79833bff5b'])
      end

      it 'doesnt return records not containing the value' do
        response = described_class.new(data).search('tags', 'Purple')
        expect(response.map{ |u| u['_id'] }).to be_empty
      end
    end
  end
end
