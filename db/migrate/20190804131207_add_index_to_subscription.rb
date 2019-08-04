class AddIndexToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_index :subscriptions, [:user_id, :question_id], unique: true
  end
end
