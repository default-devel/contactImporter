# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      ## Custom fields
      t.string  :uuid,                    null: false, default: ''  # Prevent ID usage
      # Prevent unnecesary database requests
      t.integer :pending_uploads_count,   null: false, default: 0
      t.integer :pending_contacts_count,  null: false, default: 0
      t.integer :contact_count,           null: false, default: 0
      
      ## Devise default
      # Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      # Rememberable
      t.datetime :remember_created_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    
  end
end
