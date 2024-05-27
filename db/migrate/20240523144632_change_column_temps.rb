class ChangeColumnTemps < ActiveRecord::Migration[7.0]
  def change
    change_column :temps, :market_volume, :bigint
    change_column :temps, :market_share, :float
  end
end
