class AddFolderToLists < ActiveRecord::Migration[7.1]
  def change
    add_reference :lists, :folder, null: true, foreign_key: true
  end
end
