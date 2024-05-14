class CreateTemps < ActiveRecord::Migration[7.0]
  def change
    create_table :temps do |t|
      t.string :okpd
      t.string :monthly_quarter
      t.integer :op_cost
      t.integer :ip_cost
      t.integer :sum_cost
      t.integer :op_quantity
      t.integer :ip_quantity
      t.integer :sum_quantity
      t.integer :export_cost
      t.integer :export_quantity
      t.integer :import_cost
      t.integer :import_quantity
      t.integer :prom_cost
      t.integer :prom_quantity
      t.integer :kty
      t.integer :kty_cost

      t.timestamps
    end
  end
end
