class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :lists

  has_many :events

  has_many :item_likes
  has_many :liked_items, through: :item_likes, class_name: :item

  has_many :item_wyshes
  has_many :wyshed_items, through: :item_wyshes, class_name: :item

  has_many :content_shares

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            email: true
  #validates :first_name, :last_name, presence: true
  after_create :create_auth_token

  def access_token
    Doorkeeper::AccessToken.where(resource_owner_id: self.id).first.try(:token)
  end

  def name
    @name = "#{first_name} #{last_name}"
    @name.blank? ? email : @name
  end

  private

  def create_auth_token
    # Load application which is represents API itself
    # TODO: load it once on start, for example, in the initializer.
    application = Doorkeeper::Application.where(name: 'WyshMeAPIRoot').first
    Doorkeeper::AccessToken.create!(application_id: application.id,
                                    resource_owner_id: self.id)
  end

end
