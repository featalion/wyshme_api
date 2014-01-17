class Category < ActiveRecord::Base
  has_many :categories_items, dependent: :destroy
  has_many :items, through: :categories_items

  validates :name, presence: true, uniqueness: { case_sensitive: false }

end
