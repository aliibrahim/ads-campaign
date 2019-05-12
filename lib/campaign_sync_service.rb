require_relative './connection'
require 'json'
require 'dotenv/load'

class CampaignSyncService

  class << self

    include Connection

    API_HOST     = 'https://mockbin.org'.freeze
    ADS_ENDPOINT = '/bin/fcb30500-7b98-476f-810d-463a0b8fc3df'.freeze

    attr_accessor :ads

    def perform
      raise ArgumentError, "Ads Sync Service is not enabled" unless ads_sync_enabled?
      @ads = get_ads['ads']
      get_campaign_differences
    end

    private

    def ads_sync_enabled?
      ENV['ADS_SYNC_ENABLED'] == 'true'
    end

    def get_ads
      request(http_method: :get, host: API_HOST, endpoint: ADS_ENDPOINT)
    end

    def get_campaign_differences
      differences = []
      ads.each do |remote_campaign|
        local_campaign  = Campaign.find_by(external_reference: remote_campaign['reference'])
        if local_campaign
          difference   = local_campaign.diff(remote_campaign)
          differences << difference unless difference.empty?
        end
      end
      differences.to_json
    end

  end
end
