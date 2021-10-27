class CreatePendingContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :pending_contacts do |t|
      # Required fields
      t.string :email,          null: true
      t.string :name,           null: true
      t.string :phone,          null: true
      t.string :address,        null: true
      t.date   :date_of_birth,  null: true
      t.string :franchise,      null: true
      t.string :salted_cc,      null: true
      t.string :last_digits,    null: true
      
      # For further User review
      t.string :err_list,         null: false, default: ''

      t.timestamps
    end
  end
end
