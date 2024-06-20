class AddIndex < ActiveRecord::Migration[7.0]
  def change
    add_column :temp_years, :crit_value, :boolean

    add_index :customs, :monthly_quarter
    add_index :customs, :TNVD
    add_index :customs, [:monthly_quarter, :TNVD], name: 'idx_customs_unique'

    add_index :fz223s, :monthly_quarter
    add_index :fz223s, :okpd
    add_index :fz223s, [:monthly_quarter, :okpd], name: 'idx_fz223s_unique'
    add_index :fz44s, :monthly_quarter
    add_index :fz44s, :okpd
    add_index :fz44s, [:monthly_quarter, :okpd], name: 'idx_fz44s_unique'

    add_index :listokpds, :okpd_9
    add_index :listokpds, :id_direction

    add_index :okpds, :OKPD9
    add_index :okpds, :TNVD10

    add_index :proms, :monthly_quarter
    add_index :proms, :okpd

    add_index :sum_directs, :monthly_quarter
    add_index :sum_directs, :okpd
    add_index :sum_directs, :id_direction

    add_index :temp_years, :monthly_quarter
    add_index :temp_years, :okpd
    add_index :temp_years, :critical

    add_index :temps, :monthly_quarter
    add_index :temps, :okpd

    # Индекс idx_temp_unique уже существует
    # add_index :temps, [:monthly_quarter, :okpd], unique: true, name: 'idx_temp_unique' 
  end
end
