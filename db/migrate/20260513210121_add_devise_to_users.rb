class AddDeviseToUsers < ActiveRecord::Migration[8.0] 
  def change
    change_table :users, bulk: true do |t|
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      t.index :email, unique: true
      t.index :reset_password_token, unique: true
    end
  end
end