require 'spec_helper'

RSpec.describe Campaign, type: :model do

  context 'activerecord validations' do
    it { should validate_inclusion_of(:status).in_array(%w[active paused deleted]) }
    it { should validate_presence_of(:external_reference) }
  end

end
