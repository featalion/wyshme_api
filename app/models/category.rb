class Category < ActiveRecord::Base
  has_many :categories_items, dependent: :destroy
  has_many :items, through: :categories_items

  has_attached_file :image, styles: {
    medium: "300x300>",
    thumb: "100x100>"
    }, default_url: "/images/:style/missing.png"

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :image, attachment_presence: true, unless: :test_env?
  validates_with AttachmentPresenceValidator, attributes: :image, unless: :test_env?

  private

  def test_env?
    Rails.env == 'test'
  end

end
