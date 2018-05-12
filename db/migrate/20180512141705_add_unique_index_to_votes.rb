class AddUniqueIndexToVotes < ActiveRecord::Migration[5.2]
  def change
    add_index :votes, [:votable_type, :votable_id, :user_id], unique: true
  end
end
