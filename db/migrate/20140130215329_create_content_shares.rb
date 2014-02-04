class CreateContentShares < ActiveRecord::Migration
  def change
    create_table :content_shares do |t|
      t.belongs_to :user, index: true
      t.string :content_type
      t.integer :content_id
      t.string :recipients
      t.text :message
      t.boolean :sent

      t.string :hash_id, index: true

      t.timestamps
    end
  end
end
