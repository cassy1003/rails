class AddUserColoumn < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :term, :integer
    add_column :users, :line_name, :string
    add_column :users, :facebook_name, :string
    add_column :users, :approved_at, :datetime
    add_reference :users, :approved_by, foreign_key: { to_table: :users }
    add_column :users, :role, :integer, null: false
  end
end
