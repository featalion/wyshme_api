class AddFeaturedToCategoriesItems < ActiveRecord::Migration
  def change
    add_column :categories_items, :featured, :boolean
  end
end
