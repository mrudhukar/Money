class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.string :topic
      t.text :description
      t.references :user

      t.timestamps
    end
    add_index :supports, :user_id
  end
end
