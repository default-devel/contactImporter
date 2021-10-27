class AddReferencesToContacts < ActiveRecord::Migration[6.1]
  def change
    add_reference :contacts, :user, null: false, foreign_key: true
    add_reference :contacts, :upload, null: false, foreign_key: true
  end
end
