class ContentShareSerializer < ActiveModel::Serializer
  attributes :id, :content_type, :content_id, :recipients, :message,
             :sent, :hash_id, :user_name, :user_id, :is_deleted, :errors
  has_one :content

  def user_name
    object.user.name
  end

  def user_id
    object.user.id
  end

  def is_deleted
    object.destroyed?
  end

  def errors
    object.errors.map { |f, m| { f => m } }
  end

end
