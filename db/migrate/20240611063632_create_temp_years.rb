class CreateTempYears < ActiveRecord::Migration[7.0]
  def change
    create_table :temp_years do |t|
      t.string "okpd"
      t.string "monthly_quarter"
      t.bigint "op_cost"
      t.bigint "ip_cost"
      t.bigint "sum_cost"
      t.bigint "op_quantity"
      t.bigint "ip_quantity"
      t.bigint "sum_quantity"
      t.bigint "export_cost"
      t.bigint "export_quantity"
      t.bigint "import_cost"
      t.bigint "import_quantity"
      t.bigint "prom_cost"
      t.bigint "prom_quantity"
      t.float "kty"
      t.float "kty_cost"
      t.integer "code_dethp"
      t.float "market_share"
      t.bigint "market_volume"
      t.float "part_op"
      t.float "dynamic_ip"
      t.float "dynamic_op"

      t.timestamps
    end

    add_column :temps, :part_op, :float
    add_column :temps, :dynamic_ip, :float
    add_column :temps, :dynamic_op, :float

  end
end
