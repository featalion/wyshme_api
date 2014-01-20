class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :items_count,
             :image_url, :is_deleted, :errors

  def items_count
    object.items.count
  end

  def image_url
    object.image.url
  end

  def is_deleted
    object.destroyed?
  end

  def errors
    object.errors.map { |f, m| { f => m } }
  end

end
