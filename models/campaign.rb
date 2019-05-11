class Campaign < ActiveRecord::Base

  STATUSES = %w[active paused deleted]
  validates :status, inclusion: { in: STATUSES }
  validates :external_reference, presence: true

end
