class CreateUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :uploads do |t|
      t.string :uupid,              null: false, default: ''            # Prevent ID exploitation
      t.string :original_filename,  null: false, default: 'undefined'   # For pre-cron display
      t.integer :step,              null: false, default: 0             # Steps defined in application, not for status
      t.string :filename,           null: false, default: 'undefined'   # Control field
      t.string :path,               null: false, default: ''            # Access path, for cron
      t.boolean :has_file,          null: false, default: false         # If file has been deleted after cron
      t.text :file_headers,         null: false, default: ''            # For headers match

      t.timestamps
    end
  end
end
