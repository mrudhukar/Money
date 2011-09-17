class CreateCommonItems < ActiveRecord::Migration
  def change
    create_table :common_items do |t|
      t.belongs_to :group_user
      t.string :name
      t.string :description
      t.integer :cost, :default => 0
      t.date :transaction_date
      t.integer :transaction_type, :default => CommonItem::Type::SHARED_EQUALLY

      t.timestamps
    end

    add_index :common_items, :group_user_id
  end
end
