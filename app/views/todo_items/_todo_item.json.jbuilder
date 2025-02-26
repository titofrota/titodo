json.extract! todo_item, :id, :name, :completed, :due_date, :todo_list_id, :created_at, :updated_at
json.url todo_item_url(todo_item, format: :json)
