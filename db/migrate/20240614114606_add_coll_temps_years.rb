class AddCollTempsYears < ActiveRecord::Migration[7.0]
  def change
    add_column :temp_years, :critical, :boolean
    add_column :temp_years, :okpd_rang, :integer
  end
end
