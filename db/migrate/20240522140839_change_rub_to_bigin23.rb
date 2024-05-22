class ChangeRubToBigin23 < ActiveRecord::Migration[7.0]
  def change
    change_column :proms, :cost, :bigint
    change_column :proms, :quantity, :bigint
  end
end
