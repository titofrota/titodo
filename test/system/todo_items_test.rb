require "application_system_test_case"

class TodoItemsTest < ApplicationSystemTestCase
  setup do
    @todo_item = todo_items(:one)
  end

  test "visiting the index" do
    visit todo_items_url
    assert_selector "h1", text: "Todo items"
  end

  test "should create todo item" do
    visit todo_items_url
    click_on "New todo item"

    check "Completed" if @todo_item.completed
    fill_in "Due date", with: @todo_item.due_date
    fill_in "Name", with: @todo_item.name
    fill_in "Todo list", with: @todo_item.todo_list_id
    click_on "Create Todo item"

    assert_text "Todo item was successfully created"
    click_on "Back"
  end

  test "should update Todo item" do
    visit todo_item_url(@todo_item)
    click_on "Edit this todo item", match: :first

    check "Completed" if @todo_item.completed
    fill_in "Due date", with: @todo_item.due_date
    fill_in "Name", with: @todo_item.name
    fill_in "Todo list", with: @todo_item.todo_list_id
    click_on "Update Todo item"

    assert_text "Todo item was successfully updated"
    click_on "Back"
  end

  test "should destroy Todo item" do
    visit todo_item_url(@todo_item)
    click_on "Destroy this todo item", match: :first

    assert_text "Todo item was successfully destroyed"
  end
end
