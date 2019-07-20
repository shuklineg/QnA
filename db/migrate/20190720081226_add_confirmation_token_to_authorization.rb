class AddConfirmationTokenToAuthorization < ActiveRecord::Migration[5.2]
  def change
    add_column :authorizations, :confirmation_token, :string
  end
end
