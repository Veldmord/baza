class CreateCustoms < ActiveRecord::Migration[7.0]
  def change
    create_table :customs do |t|
      t.string :export_import
      t.date :date
      t.string :TNVD
      t.string :country
      t.integer :quantity
      t.integer :USD
      t.integer :RUB

      t.timestamps
    end
  end
end
