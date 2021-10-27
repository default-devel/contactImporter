class CreateUploadStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_statuses do |t|
      t.string :slug # Cause easier to remember at dev
      t.string :name

      t.timestamps
    end
  end
end
