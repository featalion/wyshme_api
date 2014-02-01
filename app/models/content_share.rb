class ContentShare < ActiveRecord::Base
  KNOWN_CONTENT_TYPES = %w(Item Event List)

  belongs_to :user

  validates :content_id, :content_type, :recipients, presence: true
  validates :content_id, numericality: { only_integer: true, greater_than: 0 }
  validates :content_type, inclusion: { in: KNOWN_CONTENT_TYPES }

  before_save :ensure_hash_id
  after_create :send_share_email

  # Returns initialized instance of content class or nil
  def content
    @content ||= if valid_attrs?(:content_id, :content_type)
                   Object.const_get(content_type).find_by_id(content_id)
                 end
  end

  # Validates object and returns `true` if passed attributes have no
  # errors. Returns `false` otherwise.
  def valid_attrs?(*names)
    valid?
    names.inject(true) { |res, name| errors[name].blank? && res }
  end

  private

  def random_string_of_length(length)
    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
    o_len = o.length
    (0..length).map { o[ Random.rand(o_len) ] }.join
  end

  def unique_random_string_of_length(length)
    hid = random_string_of_length(length)
    while ContentShare.find_by_hash_id(hid)
       hid = random_string_of_length(length)
    end

    hid
  end

  # Generates random string with variable length [75..100] and set it
  # as `hash_id` unless it is instantiated.
  def ensure_hash_id
    self.hash_id ||= unique_random_string_of_length(75 + Random.rand(26))
  end

  def send_share_email
    UserSharesContentMailer.share_email(self).deliver
    self.sent = true
  end

end
