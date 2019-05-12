require_relative './connection'
require 'json'
class CampaignSyncService

  class << self

    include Connection

    def perform
      raise ArgumentError, "Ads Sync Service is not enabled" unless ads_sync_enabled?
    end

    private

    def ads_sync_enabled?
      ENV['ADS_SYNC_ENABLED'] == 'true'
    end

  end
end
