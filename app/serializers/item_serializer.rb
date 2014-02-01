class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :image_url,
             :likes, :wyshes, :url, :retailer, :type,
             :created_at, :updated_at, :is_deleted, :errors
  has_many :categories

  def image_url
    object.image.url
  end

  def type
    object.class.name
  end

  def is_deleted
    object.destroyed?
  end

  def errors
    object.errors.map { |f, m| { f => m } }
  end

end
