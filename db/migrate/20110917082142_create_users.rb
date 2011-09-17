class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :name,               :null => false
      t.string    :email,              :null => false
      t.string    :crypted_password
      t.string    :password_salt
      t.string    :persistence_token,  :null => false
      t.string    :perishable_token,   :null => false, :default => ""

      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns

      t.integer :net_balance, :default => 0
      t.integer :groups_count, :default => 0

      t.string :nick_name
      t.boolean :app_admin, :default => false

      t.timestamps
    end
  end
end
