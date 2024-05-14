class CreateProductDirections < ActiveRecord::Migration[7.0]
  def change
    create_table :product_directions do |t|
      t.integer :id_direction
      t.string :name_of_direction
      t.string :boss
      
      t.timestamps
    end

    create_table :functional_groups do |t|
      t.boolean :on_of
      t.integer :id_dashboard
      t.string :name_of_group
      t.string :okpd
      t.string :operator
      t.string :fz1
      t.string :fz2
      t.string :fz3
      t.string :fz4
      t.string :fz5
      t.string :fz6
      t.string :fz7
      t.string :fz8
      t.string :fz9
      t.string :fz10
      t.string :fz11
      t.string :fz12
      t.string :fz13
      t.string :fz14
      t.string :fz15
      t.string :fz16
      t.string :fz17
      t.string :fz18
      t.string :fz19
      t.string :fz20
      t.string :dh1
      t.string :dh2
      t.string :dh3
      t.string :dh4
      t.string :dh5
      t.string :dh6
      t.string :dh7
      t.string :dh8
      t.string :dh9
      t.string :dh10
      t.string :dh11
      t.string :dh12
      t.string :dh13
      t.string :dh14
      t.string :dh15
      t.string :dh16
      t.string :dh17
      t.string :dh18
      t.string :dh19
      t.string :dh20
      t.string :dh21
      t.string :dh22
      t.string :dh23
      t.string :dh24
      t.string :dh25
      t.string :dhkf1
      t.string :dhkf2
      t.string :dhkf3
      t.string :dhkf4
      t.string :dhkf5
      t.string :dhkf6
      t.string :dhkf7
      t.string :dhkf8
      t.string :dhkf9
      t.string :dhkf10
      t.string :dhkf11
      t.string :dhkf12
      t.string :dhkf13
      t.string :dhkf14
      t.string :dhkf15
      t.string :dhkf16
      t.string :dhkf17
      t.string :dhkf18
      t.string :dhkf19
      t.string :dhkf20
      t.string :dhkf21
      t.string :dhkf22
      t.string :dhkf23
      t.string :dhkf24
      t.string :dhkf25

      t.timestamps
    end

    create_table :pp719s do |t|
      t.string :company
      t.string :ogrn
      t.string :hregistration_number
      t.string :registration_number
      t.string :product
      t.string :okpd
      t.string :tnvd
      t.string :manufactured
      t.integer :point

      t.timestamps
    end

    add_column :fz223s, :updated_row, :boolean
    add_column :fz44s, :updated_row, :boolean
    add_column :customs, :updated_row, :boolean
    add_column :proms, :updated_row, :boolean

    add_column :listokpds, :id_direction, :integer

    add_column :temps, :code_dethp, :integer
    add_column :temps, :market_share, :integer
    add_column :temps, :market_volume, :integer


  end
end
