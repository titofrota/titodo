require "test_helper"

class TodoListTest < ActiveSupport::TestCase
  test "should not save todo list without name" do
    todo_list = TodoList.new
    assert_not todo_list.save, "Saved the todo list without a name"
  end

  test "should save todo list with a name" do
    todo_list = TodoList.new(name: "My Todo List")
    assert todo_list.save, "Couldn't save the todo list with a name"
  end

  test "should have many items" do
    todo_list = TodoList.create(name: "Test List")
    todo_item1 = TodoItem.create(name: "Item 1", todo_list: todo_list)
    todo_item2 = TodoItem.create(name: "Item 2", todo_list: todo_list)

    assert_equal 2, todo_list.items.count, "Todo list should have many items"
  end

  test "should destroy associated todo items when todo list is destroyed" do
    todo_list = TodoList.create(name: "Test List")
    todo_item = TodoItem.create(name: "Item 1", todo_list: todo_list)

    assert_difference "TodoItem.count", -1 do
      todo_list.destroy
    end
  end
end
