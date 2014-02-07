class EventSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :date, :description,
             :type, :created_at, :is_deleted, :errors
        
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
