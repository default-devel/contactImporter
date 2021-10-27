class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      # Required fields
      t.string :email,          null: false
      t.string :name,           null: false
      t.string :phone,          null: false
      t.string :address,        null: false
      t.date   :date_of_birth,  null: false
      t.string :franchise,      null: false
      t.string :salted_cc,      null: false
      t.string :last_digits,    null: false

      # I need something relevant to fill the index
      # I'm a dashboard entusiast
      t.boolean :is_favorite,    null: true

      t.timestamps
    end
  end
end
