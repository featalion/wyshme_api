class ListSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :event, :event_at,
             :item_order, :user_id, :type, :is_deleted, :errors
  has_many :items

  def type
    object.class.name
  end

  def user_id
    object.user_id
  end

  def is_deleted
    object.destroyed?
  end

  def errors
    object.errors.map { |f, m| { f => m } }
  end

  def items
    object.ordered_items
  end

end
