# frozen_string_literal: true
require 'spec_helper'

RSpec.describe CampaignSyncService, type: :service do
  let(:subject) { CampaignSyncService }

  let(:mocked_response) {
    "{\"ads\":[{\"reference\":\"1\",\"status\":\"enabled\",\"description\":\"Description for campaign 11\"},{\"reference\":\"2\",\"status\":\"disabled\",\"description\":\"Description for campaign 12\"},{\"reference\":\"3\",\"status\":\"enabled\",\"description\":\"Description for campaign 13\"}]}"
  }

  context '#perform' do
    context 'if ads sync service is NOT enabled on ENV' do
      before(:example) do
        ENV['ADS_SYNC_ENABLED'] = 'false'
      end
      it 'should raise an error' do
        expect{ subject.perform }.to raise_error(ArgumentError)
      end
    end

    context 'if ads sync service is enabled on ENV' do
      before(:example) do
        ENV['ADS_SYNC_ENABLED'] = 'true'
      end

      it 'does not raise an error' do
        expect{ subject.perform }.to_not raise_error(ArgumentError)
      end

      context 'when trying to get the data from the API' do
        before do
          stub_request(:get, "https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df").
          with(
            headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type'=>'application/json',
              'User-Agent'=>'Faraday v0.15.4'
            }).
            to_return(status: 200, body: mocked_response, headers: {})
            subject.perform
        end

        it 'sets the ads to the data received' do
          expect(subject.ads).to eq(JSON.parse(mocked_response)['ads'])
        end
      end
    end
  end
end
