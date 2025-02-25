class CreateTodoItems < ActiveRecord::Migration[8.0]
  def change
    create_table :todo_items do |t|
      t.string :name
      t.boolean :completed, default: false
      t.date :due_date
      t.belongs_to :todo_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
