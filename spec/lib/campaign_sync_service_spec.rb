# frozen_string_literal: true
require 'spec_helper'

RSpec.describe CampaignSyncService, type: :service do
  let(:subject) { CampaignSyncService }

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
    end
  end
end
