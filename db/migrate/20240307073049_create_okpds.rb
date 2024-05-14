class CreateOkpds < ActiveRecord::Migration[7.0]
  def change
    create_table :okpds do |t|
      t.string :OKPD6
      t.string :OKPD6Trans
      t.string :OKPD9
      t.string :OKPD9Trans
      t.string :TNVD6
      t.string :TNVD6Trans
      t.string :TNVD10
      t.string :TNVD10Trans

      t.timestamps
    end
  end
end
