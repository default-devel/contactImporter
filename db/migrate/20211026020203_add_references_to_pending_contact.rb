class AddReferencesToPendingContact < ActiveRecord::Migration[6.1]
  def change
    add_reference :pending_contacts, :user, null: false, foreign_key: true
    add_reference :pending_contacts, :upload, null: false, foreign_key: true
  end
end