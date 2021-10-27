class PendingContact < ApplicationRecord
  belongs_to :user
  belongs_to :upload

  # Errors on create will be stored here
  serialize :err_list
end