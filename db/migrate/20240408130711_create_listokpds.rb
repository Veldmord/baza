class CreateListokpds < ActiveRecord::Migration[7.0]
  def change
    create_table :listokpds do |t|
      t.string :okpd_2
      t.text :trans_2
      t.string :okpd_4
      t.text :trans_4
      t.string :okpd_6
      t.text :trans_6
      t.string :okpd_9
      t.text :trans_9
      t.text :notes
      t.text :dep_1440
      t.text :notes_1440
      t.string :nic
      t.string :full_name
      t.text :prod_direct

      t.timestamps
    end
  end
end
