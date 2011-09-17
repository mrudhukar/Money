class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :code

      t.column :redeemed_at, :datetime
      t.column :redeemed_by_id, :integer

      t.column :expires_on, :datetime

      t.timestamps
    end
  end
end
