class ContentShareSerializer < ActiveModel::Serializer
  attributes :id, :content_type, :content_id, :recipients,
             :message, :sent, :is_deleted, :errors

  def is_deleted
    object.destroyed?
  end

  def errors
    object.errors.map { |f, m| { f => m } }
  end

end
