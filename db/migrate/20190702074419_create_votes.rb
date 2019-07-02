class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.belongs_to :votable, polymorphic: true
      t.belongs_to :user, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end
  end
end
