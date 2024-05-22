class ChangeRubToBigint < ActiveRecord::Migration[7.0]
  def change
    change_column :customs, :RUB, :bigint
    change_column :fz223s, :Contract_Amount, :bigint
    change_column :fz44s, :Contract_Amount, :bigint
    change_column :temps, :op_cost, :bigint
    change_column :temps, :ip_cost, :bigint
    change_column :temps, :sum_cost, :bigint
    change_column :temps, :op_quantity, :bigint
    change_column :temps, :ip_quantity, :bigint
    change_column :temps, :sum_quantity, :bigint
    change_column :temps, :export_cost, :bigint
    change_column :temps, :export_quantity, :bigint
    change_column :temps, :import_cost, :bigint
    change_column :temps, :import_quantity, :bigint
    change_column :temps, :prom_cost, :bigint
    change_column :temps, :prom_quantity, :bigint

    change_column :temps, :kty, :float
    change_column :temps, :kty_cost, :float

  
  end
end
