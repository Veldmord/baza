class CreateFz223s < ActiveRecord::Migration[7.0]
  def change
    create_table :fz223s do |t|
      t.string :file_name
      t.string :okpd
      t.text :okpd_name
      t.integer :Country_Code
      t.string :Manufacturer_Country
      t.text :Commodity_by_Contract
      t.string :Registration_Number
      t.string :Contract_Number
      t.date :Contract_Date
      t.date :Publication_Date
      t.date :End_Date
      t.string :Unit_of_Measure
      t.string :OP_IP
      t.integer :Quantity
      t.integer :Price_per_Unit
      t.integer :Position_Amount
      t.integer :Contract_Amount
      t.text :Contract_Documents
      
      t.timestamps
    end
  end
end
