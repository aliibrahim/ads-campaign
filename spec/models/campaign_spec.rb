require 'spec_helper'
require 'json'
RSpec.describe Campaign, type: :model do

  let(:campaign) { Campaign.create(external_reference: '1', status: 'active', ad_description: 'Some Description') }

  context 'activerecord validations' do
    it { should validate_inclusion_of(:status).in_array(%w[active paused deleted]) }
    it { should validate_presence_of(:external_reference) }
    it { should validate_uniqueness_of(:external_reference).case_insensitive }
  end

  context '#diff' do
    context 'when there are differences between local and remote campaigns' do
      let(:remote_campaign) {
        {
          reference: '1',
          status: 'paused',
          description: 'Description for campaign 11'
        }.to_json
      }
      let(:difference) {
        {
          remote_reference: '1',
          discrepancies: [
            {
              status: {
                local:"active",
                remote:"paused"
              }
            },
            {
              description:
              {
                local: "Some Description",
                remote: "Description for campaign 11"
              }
            }
          ]
        }
      }
      it 'return the difference between local and remote version of campaign' do
        expect(campaign.diff(JSON.parse(remote_campaign))).to eq(difference)
      end
    end

    context 'when there are NO differences between local and remote campaigns' do

      let(:remote_campaign) {
        {
          reference: '1',
          status: 'active',
          description: 'Some Description'
        }.to_json
      }
      let(:difference) { {} }

      it 'return the difference between local and remote version of campaign' do
        expect(campaign.diff(JSON.parse(remote_campaign))).to eq(difference)
      end
    end
  end

end
