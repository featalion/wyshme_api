class AddTimestampsToWysh < ActiveRecord::Migration
  def change
    add_column :item_wyshes, :created_at, :datetime
    add_column :item_wyshes, :updated_at, :datetime
  end
end
