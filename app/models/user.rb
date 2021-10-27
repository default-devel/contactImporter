class User < ApplicationRecord
  # Include restricted devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable,
  # :recoverable, :validatable, :omniauthable
  devise :database_authenticatable, :registerable, :rememberable
  
  has_many :contacts
  has_many :uploads
  has_many :pending_contacts

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP }
  validates :uuid, uniqueness: true

  # Fast filter
  def get_pending_uploads
    self.uploads.where(status: UploadStatus.find_by(slug:'hold'))
  end
  # Uniqueness for url
  before_create do
    uuid = SecureRandom.alphanumeric(8)
    redo if User.exists?(uuid: uuid)
    self.uuid = uuid
  end
end