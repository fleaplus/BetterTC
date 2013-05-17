class AddPeriodIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :period_id, :integer
  end
end
