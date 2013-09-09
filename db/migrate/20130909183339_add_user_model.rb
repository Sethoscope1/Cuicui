class AddUserModel < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.string :twitter_user_id
      t.string :screen_name

      t.timestamps
    end

    create_table :status do |t|
      t.string :twitter_status_id
      t.string :twitter_user_id
      t.string :body

      t.timestamps
    end

    add_index :users, :twitter_user_id, :unique => true
    add_index :status, :twitter_status_id, :unique => true

  end
end
