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

  describe '#search' do
    let(:json) {
      <<-JSON
        [
          {
            "_id": 101,
            "url": "http://initech.zendesk.com/api/v2/organizations/101.json",
            "external_id": "9270ed79-35eb-4a38-a46f-35725197ea8d",
            "name": "Enthaze",
            "domain_names": [
              "kage.com",
              "ecratic.com",
              "endipin.com",
              "zentix.com"
            ],
            "created_at": "2016-05-21T11:10:28 -10:00",
            "details": "MegaCorp",
            "shared_tickets": false,
            "tags": [
              "Fulton",
              "West",
              "Rodriguez",
              "Farley"
            ]
          },
          {
            "_id": 102,
            "url": "http://initech.zendesk.com/api/v2/organizations/102.json",
            "external_id": "7cd6b8d4-2999-4ff2-8cfd-44d05b449226",
            "name": "Nutralab",
            "domain_names": [
              "trollery.com",
              "datagen.com",
              "bluegrain.com",
              "dadabase.com"
            ],
            "created_at": "2016-04-07T08:21:44 -10:00",
            "details": "Non profit",
            "shared_tickets": false,
            "tags": [
              "Cherry",
              "Collier",
              "Fuentes",
              "Trevino"
            ]
          },
          {
            "_id": 103,
            "url": "http://initech.zendesk.com/api/v2/organizations/103.json",
            "external_id": "e73240f3-8ecf-411d-ad0d-80ca8a84053d",
            "name": "Plasmos",
            "domain_names": [
              "comvex.com",
              "automon.com",
              "verbus.com",
              "gogol.com"
            ],
            "created_at": "2016-05-28T04:40:37 -10:00",
            "details": "",
            "shared_tickets": true,
            "tags": [
              "Parrish",
              "Lindsay",
              "Armstrong",
              "Vaughn"
            ]
          }
        ]
      JSON
    }

    let(:data) { JSON.load(json) }

    context 'strings' do
      it 'returns matches on string fields' do
        response = described_class.new(data).search('name', 'Enthaze')
        expect(response.map{ |u| u['_id'] }).to match_array([101])
      end

      it 'doesnt return partial matches' do
        response = described_class.new(data).search('name', 'Enthaz')
        expect(response.map{ |u| u['_id'] }).to be_empty
      end

      it 'matches empty values' do
        response = described_class.new(data).search('details', '')
        expect(response.map{ |u| u['_id'] }).to match_array([103])
      end
    end

    context 'integers' do
      it 'returns matches on integer fields' do
        response = described_class.new(data).search('_id', 101)
        expect(response.map{ |u| u['_id'] }).to match_array([101])
      end
    end

    context 'booleans' do
      it 'returns matches on boolean fields' do
        response = described_class.new(data).search('shared_tickets', false)
        expect(response.map{ |u| u['_id'] }).to match_array([101, 102])
      end
    end

    context 'arrays' do
      it 'returns matches if array contains the value' do
        response = described_class.new(data).search('tags', 'Fulton')
        expect(response.map{ |u| u['_id'] }).to match_array([101])
      end

      it 'doesnt return records not containing the value' do
        response = described_class.new(data).search('tags', 'Purple')
        expect(response.map{ |u| u['_id'] }).to be_empty
      end
    end
  end
end
