class AddUserToReward < ActiveRecord::Migration[5.2]
  def change
    add_reference :rewards, :answer, foreign_key: true
  end
end
