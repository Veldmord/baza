class BigIntFz < ActiveRecord::Migration[7.0]
  def change
    change_column :fz223s, :Price_per_Unit, :bigint
    change_column :fz223s, :Position_Amount, :bigint
    change_column :fz44s, :Price_per_Unit, :bigint
    change_column :fz44s, :Position_Amount, :bigint
  end
end
