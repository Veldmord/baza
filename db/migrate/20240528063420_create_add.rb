class CreateAdd < ActiveRecord::Migration[7.0]
  def change
    create_table :sum_directs do |t|
      t.string :okpd
      t.string :monthly_quarter
      t.bigint :op_cost
      t.bigint :ip_cost
      t.bigint :sum_cost
      t.bigint :op_quantity
      t.bigint :ip_quantity
      t.bigint :sum_quantity
      t.bigint :export_cost
      t.bigint :export_quantity
      t.bigint :import_cost
      t.bigint :import_quantity
      t.bigint :prom_cost
      t.bigint :prom_quantity
      t.bigint :kty
      t.float  :kty_cost
      t.bigint :market_volume
      t.float  :market_share
      t.integer :id_direction

      t.timestamps
    end
  end
end
