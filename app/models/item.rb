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
  validates_with AttachmentPresenceValidator,
                 attributes: :image, unless: :test_env?

  scope :with_categories_items, -> { includes(:categories_items) }

  scope :featured, -> {
    with_categories_items.where(categories_items: { featured: true })
  }

  scope :featured_for_category, -> (ids) {
    featured.where(categories_items: { category_id: ids })
  }

  scope :liked, -> (user_id) {
    joins(:item_likes).where(item_likes: { user_id: user_id })
  }

  scope :wyshed, -> (user_id) {
    joins(:item_wyshes).where(item_wyshes: { user_id: user_id })
  }

  scope :for_category, ->(ids) {
    with_categories_items.where(categories_items: { category_id: ids })
  }

  scope :for_list, -> (ids) {
    joins(:items_lists).where(items_lists: { list_id: ids })
  }

  scope :for_user_public_lists, ->(user){
    joins(:lists).where(lists: { user_id: user, public: true })
  }

  def self.most_recent_wyshes(num, user_id = nil)
    items = joins(:item_wyshes)
    items = items.where(item_wyshes: { user_id: user_id }) if user_id
    items.order('item_wyshes.id DESC').limit(num).uniq
  end

  private

  def test_env?
    Rails.env == 'test'
  end

end
