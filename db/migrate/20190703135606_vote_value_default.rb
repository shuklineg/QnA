class VoteValueDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:votes, :value, from: nil, to: 0)
  end
end
