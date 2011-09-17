class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.integer :user_id
      t.integer :group_id
      t.float :balance, :default => 0.0
      t.integer :status, :default => GroupUser::Status::ACTIVE

      t.timestamps
    end
    add_index :group_users, [:user_id, :group_id]
  end
end
