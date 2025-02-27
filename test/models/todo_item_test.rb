require "test_helper"

class TodoItemTest < ActiveSupport::TestCase
  test "should not save todo item without name" do
    todo_item = TodoItem.new
    assert_not todo_item.save, "Saved the todo item without a name"
  end

  test "should save todo item with a name" do
    todo_list = TodoList.create(name: "Test List")
    todo_item = TodoItem.new(name: "Test Item", todo_list: todo_list)
    assert todo_item.save, "Couldn't save the todo item with a name"
  end

  test "should not save todo item with due_date in the past" do
    todo_list = TodoList.create(name: "Test List")
    todo_item = TodoItem.new(name: "Test Item", todo_list: todo_list, due_date: Date.yesterday)
    assert_not todo_item.save, "Saved the todo item with a past due_date"
  end

  test "should save todo item with valid due_date" do
    todo_list = TodoList.create(name: "Test List")
    todo_item = TodoItem.new(name: "Test Item", todo_list: todo_list, due_date: Date.today)
    assert todo_item.save, "Couldn't save the todo item with a valid due_date"
  end

  test "should return completed items" do
    todo_list = TodoList.create(name: "Test List")
    completed_item = TodoItem.create(name: "Completed Item", todo_list: todo_list, completed: true)
    pending_item = TodoItem.create(name: "Pending Item", todo_list: todo_list, completed: false)

    assert_includes TodoItem.completed, completed_item, "Completed items scope did not include the completed item"
    assert_not_includes TodoItem.completed, pending_item, "Completed items scope included the pending item"
  end

  test "should return pending items" do
    todo_list = TodoList.create(name: "Test List")
    completed_item = TodoItem.create(name: "Completed Item", todo_list: todo_list, completed: true)
    pending_item = TodoItem.create(name: "Pending Item", todo_list: todo_list, completed: false)

    assert_includes TodoItem.pending, pending_item, "Pending items scope did not include the pending item"
    assert_not_includes TodoItem.pending, completed_item, "Pending items scope included the completed item"
  end
end
