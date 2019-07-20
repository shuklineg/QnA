class AddConfirmationTokenIndexToAuthorization < ActiveRecord::Migration[5.2]
  def change
    add_index :authorizations, :confirmation_token, unique: true
  end
end
