class DeviseCreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      ## Database authenticatable
      t.string :username,           null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: true, default: ""
      t.string
      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
      t.string   "user_id"
      t.boolean  "is_permit",  default: false
      t.boolean  "is_admin",   default: false
      t.string   "thumb"

      t.timestamps null: false
    end

    add_index :members, :email,                unique: true
    add_index :members, :reset_password_token, unique: true
    # add_index :members, :confirmation_token,   unique: true
    # add_index :members, :unlock_token,         unique: true
  end
end
