class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.references :employee
      t.references :job
      t.integer :punch_in
      t.integer :punch_out
      t.decimal :length, precision: 2

      t.timestamps
    end
    add_index :periods, :employee_id
    add_index :periods, :job_id
  end
end
