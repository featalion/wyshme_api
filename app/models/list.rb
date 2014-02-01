class List < ActiveRecord::Base
  belongs_to :user

  has_many :items_lists, dependent: :destroy
  has_many :items, through: :items_lists

  has_many :events_lists
  has_many :events, through: :events_lists

  validates :user, :name, presence: true

  def ordered_items
    itms = self.items.to_a
    if item_order.present?
      item_order.split(',').each_with_object([]) do |id, res|
        res << itms.select { |i| i.id == id.to_i }.first
      end
    else
      itms
    end
  end

end
