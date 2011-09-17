class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.belongs_to :common_item
      t.belongs_to :user, :null => false
      t.integer :default_amount, :default => 0

      t.timestamps
    end
    add_index :items, [:user_id, :common_item_id]

  end
end
