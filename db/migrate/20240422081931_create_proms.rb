class CreateProms < ActiveRecord::Migration[7.0]
  def change
    create_table :proms do |t|
      t.string :file_name
      t.string :monthly_quarter
      t.string :okpd
      t.integer :cost
      t.integer :quantity

      t.timestamps
    end

    add_column :listokpds, :ekb, :string
    add_column :listokpds, :thematically_fixed, :string

    add_column :fz44s, :monthly_quarter, :string
    add_column :fz223s, :monthly_quarter, :string

    add_column :customs, :monthly_quarter, :string



  end
end
