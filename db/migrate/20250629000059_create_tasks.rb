class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.datetime :due_date
      t.boolean :completed
      t.integer :priority
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
