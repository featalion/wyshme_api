class Item < ActiveRecord::Base
  has_many :items_lists, dependent: :destroy
  has_many :lists, through: :items_lists

  has_many :categories_items, dependent: :destroy
  has_many :categories, through: :categories_items

  has_many :item_likes
  has_many :item_wyshes

  has_attached_file :image, styles: {
    medium: "300x300>",
    thumb: "100x100>"
    }, default_url: "/images/:style/missing.png"

  validates :name, presence: true
  validates :image, attachment_presence: true, unless: :test_env?
  validates_with AttachmentPresenceValidator, attributes: :image, unless: :test_env?

  scope :featured, -> {
    includes(:categories_items).where(categories_items: { featured: true })
  }

  scope :featured_for_category, ->(ids) {
    featured.where(categories_items: { category_id: ids })
  }

  private

  def test_env?
    Rails.env == 'test'
  end

end
