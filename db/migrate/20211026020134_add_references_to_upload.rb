class AddReferencesToUpload < ActiveRecord::Migration[6.1]
  def change
    add_reference :uploads, :user, null: false, foreign_key: true
    add_reference :uploads, :upload_status, null: false, foreign_key: true
  end
end
