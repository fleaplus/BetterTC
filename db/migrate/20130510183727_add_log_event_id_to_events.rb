class AddLogEventIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :log_event_id, :integer
  end
end
