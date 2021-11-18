class AddRolesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :consultation, :boolean, default: true
    add_column :users, :attendance, :boolean, default: false
    add_column :users, :admin, :boolean, default: false
  end
end
