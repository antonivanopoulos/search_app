[
  "app/utils/user_searcher.rb",
].each { |f| require_relative "../../#{f}" }

require 'json'

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

  describe '#search' do
    let(:json) {
      <<-JSON
        [
          {
            "_id": 1,
            "url": "http://initech.zendesk.com/api/v2/users/1.json",
            "external_id": "74341f74-9c79-49d5-9611-87ef9b6eb75f",
            "name": "Francisca Rasmussen",
            "alias": "Miss Coffey",
            "created_at": "2016-04-15T05:19:46 -10:00",
            "active": true,
            "verified": true,
            "shared": false,
            "locale": "en-AU",
            "timezone": "Sri Lanka",
            "last_login_at": "2013-08-04T01:03:27 -10:00",
            "email": "coffeyrasmussen@flotonic.com",
            "phone": "8335-422-718",
            "signature": "Don't Worry Be Happy!",
            "organization_id": 119,
            "tags": [
              "Springville",
              "Sutton",
              "Hartsville/Hartley",
              "Diaperville"
            ],
            "suspended": true,
            "role": "admin"
          },
          {
            "_id": 2,
            "url": "http://initech.zendesk.com/api/v2/users/2.json",
            "external_id": "c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2",
            "name": "Cross Barlow",
            "alias": "Miss Joni",
            "created_at": "2016-06-23T10:31:39 -10:00",
            "active": true,
            "verified": true,
            "shared": false,
            "locale": "zh-CN",
            "timezone": "Armenia",
            "last_login_at": "2012-04-12T04:03:28 -10:00",
            "email": "jonibarlow@flotonic.com",
            "phone": "9575-552-585",
            "signature": "Don't Worry Be Happy!",
            "organization_id": 106,
            "tags": [
              "Foxworth",
              "Woodlands",
              "Herlong",
              "Henrietta"
            ],
            "suspended": false,
            "role": "admin"
          },
          {
            "_id": 3,
            "url": "http://initech.zendesk.com/api/v2/users/3.json",
            "external_id": "85c599c1-ebab-474d-a4e6-32f1c06e8730",
            "name": "Ingrid Wagner",
            "alias": "Miss Buck",
            "created_at": "2016-07-28T05:29:25 -10:00",
            "active": false,
            "verified": false,
            "shared": false,
            "locale": "en-AU",
            "timezone": "Trinidad and Tobago",
            "last_login_at": "2013-02-07T05:53:38 -11:00",
            "email": "buckwagner@flotonic.com",
            "phone": "9365-482-943",
            "signature": "",
            "organization_id": 104,
            "tags": [
              "Mulino",
              "Kenwood",
              "Wescosville",
              "Loyalhanna"
            ],
            "suspended": false,
            "role": "end-user"
          }
        ]
      JSON
    }

    let(:data) { JSON.load(json) }

    context 'strings' do
      it 'returns matches on string fields' do
        response = described_class.new(data).search('name', 'Francisca Rasmussen')
        expect(response.map{ |u| u['_id'] }).to match_array([1])
      end

      it 'doesnt return partial matches' do
        response = described_class.new(data).search('name', 'Francisca')
        expect(response.map{ |u| u['_id'] }).to be_empty
      end

      it 'matches empty values' do
        response = described_class.new(data).search('signature', '')
        expect(response.map{ |u| u['_id'] }).to match_array([3])
      end
    end

    context 'integers' do
      it 'returns matches on integer fields' do
        response = described_class.new(data).search('_id', 1)
        expect(response.map{ |u| u['_id'] }).to match_array([1])
      end
    end

    context 'booleans' do
      it 'returns matches on boolean fields' do
        response = described_class.new(data).search('active', true)
        expect(response.map{ |u| u['_id'] }).to match_array([1, 2])
      end
    end

    context 'arrays' do
      it 'returns matches if array contains the value' do
        response = described_class.new(data).search('tags', 'Springville')
        expect(response.map{ |u| u['_id'] }).to match_array([1])
      end

      it 'doesnt return records not containing the value' do
        response = described_class.new(data).search('tags', 'Purple')
        expect(response.map{ |u| u['_id'] }).to be_empty
      end
    end
  end
end
