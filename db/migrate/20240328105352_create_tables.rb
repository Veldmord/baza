class CreateTables < ActiveRecord::Migration[7.0]
  def change
    create_table :tables do |t|
      t.string :table_name
      t.integer :count_records
      t.string :link
      t.text :about

      t.timestamps
    end
  end
end
