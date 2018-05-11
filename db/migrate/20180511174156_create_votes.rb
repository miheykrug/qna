class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :rating, default: 0, null: false
      t.references :votable, polymorphic: true
      t.references :user

      t.timestamps
    end
  end
end
