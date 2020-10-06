class RenameVisibleColumnToItems < ActiveRecord::Migration[6.0]
  def change
    rename_column :items, :visible, :status
  end
end
