class CreateCampaigns < ActiveRecord::Migration[5.2]

  def change
    create_table :campaigns do |t|
      t.integer :job_id
      t.string :status
      t.string :external_reference
      t.text :ad_description
    end

    add_index :campaigns, :job_id
    add_index :campaigns, :external_reference
  end

end
