class Campaign < ActiveRecord::Base

  STATUSES = %w[active paused deleted]
  validates :status, inclusion: { in: STATUSES }
  validates :external_reference, presence: true
  validates :external_reference, uniqueness: true, case_sensitive: false

  ATTRS_MAPPER = {
    status: 'status',
    ad_description: 'description',
    external_reference: 'reference'
  }

  def diff(remote_campaign)
    diff_hash = {
      remote_reference: remote_campaign['reference'],
      discrepancies: []
    }
    ATTRS_MAPPER.keys.each do |attr|
      remote_value = remote_campaign[ATTRS_MAPPER[attr]]
      local_value  = self.send(attr.to_sym)
      if remote_value && remote_value != local_value
        diff_hash[:discrepancies] << {
          "#{ATTRS_MAPPER[attr]}": {
            'local': local_value,
            'remote': remote_value
          }
        }
      end
    end
    diff_hash[:discrepancies].empty? ? {} : diff_hash
  end

end
