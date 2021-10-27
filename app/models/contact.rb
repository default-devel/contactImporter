class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :upload

  validates_presence_of :name, :email, :phone, :date_of_birth, :address, :franchise, :salted_cc, :last_digits
  validates :name, format: { with: /\A[\w\s-]*\z/, message: 'invalid characters detected'}
  validates :email, uniqueness: { scope: :user_id } , format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: 'invalid'} 
  validates :phone, format: { with: /\(\+[0-9]{2}\)\s[0-9]{3}(\s|-)[0-9]{3}(\s|-)[0-9]{2}(\s|-)[0-9]{2}/, message: 'invalid'}
  # This validation execute only if the field is not into common Date formats
  # ApplicationRecord identify the dataType and converts to valid Date format during validation
  # The Project specifics required ('%Y%m%d' || '%F'), but can't be validaded on Model due behaviors
  # and handling Model errors handling outside the model it's kind of ugly. This is on me.
  validates :date_of_birth, format: { with: /\A\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])\z/, message: 'invalid'}
  validate :has_identified_franchise

  private
  def has_identified_franchise
    # Upload.get_card_franchise returns only (value || false)
    # When false is translated into string, ApplicationRecord converts to "0"
    # Reject if not value
    errors.add(:franchise, " not identified") if franchise == "0"
  end
end
