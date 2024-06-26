class AddColl < ActiveRecord::Migration[7.0]
  def change
    add_column :temp_years, :name_okpd, :string
  end
end
